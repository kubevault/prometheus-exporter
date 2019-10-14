---
title: GCPAccessKeyRequest | Vault Secret Engine
menu:
  docs_{{ .version }}:
    identifier: gcpaccesskeyrequest-secret-engine-crds
    name: GCPAccessKeyRequest
    parent: secret-engine-crds-concepts
    weight: 15
menu_name: docs_{{ .version }}
section_menu_id: concepts
---

> New to KubeVault? Please start [here](/docs/concepts/README.md).

# GCPAccessKeyRequest CRD

`GCPAccessKeyRequest` CRD is to generate gcp secret (i.e. OAuth2 Access Token or Service Account Key)
using vault. If `GCPAccessKeyRequest` is approved, then vault operator will issue credentials from vault
and create Kubernetes Secret containing these credentials. The Secret name will be specified in `status.secret.name` field.
The operator will also create `ClusterRole` and `RoleBinding` for the k8s secret. 

When a `GCPAccessKeyRequest` is created, it make an  access key request to vault under a `roleset`.
Hence a [GCPRole](/docs/concepts/secret-engine-crds/gcp-secret-engine/gcprole.md) CRD which is successfully configured,
is prerequisite for creating a `GCPAccessKeyRequest`.

```yaml
apiVersion: engine.kubevault.com/v1alpha1
kind: GCPAccessKeyRequest
metadata:
  name: <name>
  namespace: <namespace>
spec:
  ... ...
status:
  ... ...
```

Vault operator performs the following operations when a GCPAccessKeyRequest CRD is created:

- Checks whether `status.conditions[].type` is `Approved` or not
- If Approved, makes gcp access key request to vault
- Creates a Kubernetes Secret which contains the gcp secrets
- Sets the name of the k8s secret to GCPAccessKeyRequest's `status.secret`
- Provides permissions of kubernetes secret to specified objects or user identities

## GCPAccessKeyRequest Spec

GCPAccessKeyRequest `Spec` contains information about 
[GCPRole](/docs/concepts/secret-engine-crds/gcp-secret-engine/gcprole.md) and subjects.

```yaml
spec:
  roleRef: <GCPRole-reference>
  subjects: <list-of-subjects>
```
`Spec` contains two additional fields only if the referred GCPRole has `spec.secretType` of `service_account_key`. 

```yaml
spec:
  roleRef: <GCPRole-reference>
  subjects: <list-of-subjects>
  keyAlgorithm: <algorithm_used_to_generate_key>
  keyType: <private_key_type>
``` 

GCPAccessKeyRequest Spec has following fields:

### spec.roleRef

`spec.roleRef` is a `required` field that specifies the 
[GCPRole](/docs/concepts/secret-engine-crds/gcp-secret-engine/gcprole.md) against which credential will be issued.

It has following field:
- `roleRef.apiGroup` : `optional`. Specifies the APIGroup of the resource being referenced.
- `roleRef.kind` : `optional`. Specifies the kind of the resource being referenced.
- `roleRef.name` : `Required`. Specifies the name of the object being referenced.
- `roleRef.namespace` : `Required`. Specifies the namespace of the referenced object.

```yaml
spec:
  roleRef:
    name: gcp-role
    namespace: demo
```

### spec.subjects

`spec.subjects` is a `required` field that contains a list of references to the object or 
user identities where the `RoleBinding` applies to. These object or user identities will have
read access of the k8s credential secret. This can either hold a direct API object reference, 
or a value for non-objects such as user and group names.

It has following fields:
- `kind` : `required`. Specifies the iind of object being referenced. Values defined by 
  this API group are "User", "Group", and "ServiceAccount". If the Authorizer does not 
  recognized the kind value, the Authorizer should report an error.

- `apiGroup` : `optional`. Specifies the APIGroup that holds the API group of the referenced subject.
   Defaults to `""` for ServiceAccount subjects.

- `name` : `required`. Specifies the name of the object being referenced.

- `namespace`: `required`. Specifies the namespace of the object being referenced.

```yaml
spec:
  subjects:
    - kind: ServiceAccount
      name: sa
      namespace: demo
```
### spec.keyAlgorithm 

`spec.keyAlgorithm` is an `optional` field that specifies the key algorithm 
used to generate key. Defaults to 2k RSA key You probably should not choose other values (i.e. 1k), 
but accepted values are `KEY_ALG_UNSPECIFIED`, `KEY_ALG_RSA_1024`, `KEY_ALG_RSA_2048`  

```yaml
spec:
  keyAlgorithm: KEY_ALG_RSA_2048
```

### spec.keyType

`spec.keyType` is an `optional` field that specifies the private key type to generate. 
Defaults to JSON credentials file. Accepted values are `TYPE_UNSPECIFIED`, `TYPE_GOOGLE_CREDENTIALS_FILE`

```yaml
spec:
  keyType: TYPE_GOOGLE_CREDENTIALS_FILE
``` 

## GCPAccessKeyRequest Status

`status` shows the status of the GCPAccessKeyRequest. It is maintained by Vault operator. It contains following fields:

- `secret` : Specifies the name of the secret containing GCP credential.

- `lease` : Contains lease information of the issued credential.

- `conditions` : Represent observations of a GCPAccessKeyRequest.

    ```yaml
    status:
      conditions:
        - type: Approved
    ```

  It has following field:
  - `conditions[].type` : `Required`. Specifies request approval state. Supported type: `Approved` and `Denied`.
  - `conditions[].reason` : `Optional`. Specifies brief reason for the request state.
  - `conditions[].message` : `Optional`. Specifies human readable message with details about the request state.

> Note: GCP credential will be issued if `conditions[].type` is `Approved`. Otherwise, Vault operator will not issue any credential.
