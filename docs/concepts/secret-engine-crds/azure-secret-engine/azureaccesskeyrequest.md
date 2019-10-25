---
title: AzureAccessKeyRequest | Vault Secret Engine
menu:
  docs_{{ .version }}:
    identifier: azureaccesskeyrequest-secret-engine-crds
    name: AzureAccessKeyRequest
    parent: secret-engine-crds-concepts
    weight: 15
menu_name: docs_{{ .version }}
section_menu_id: concepts
---

> New to KubeVault? Please start [here](/docs/concepts/README.md).

![AzureAccessKeyRequest CRD](/docs/images/concepts/azure_accesskey_request.svg)

# AzureAccessKeyRequest CRD

`AzureAccessKeyRequest` CRD can be used to request a new service principal based 
on a named role using a Vault server. If `AzureAccessKeyRequest` is approved, then KubeVault operator
will issue credentials via a Vault server and create Kubernetes Secret containing these credentials. 
The Secret name will be set in `status.secret.name` field. The operator will also create 
`ClusterRole` and `ClusterRoleBinding` for the k8s secret.

When a `AzureAccessKeyRequest` is created, 
it makes a request to a Vault server for a new service principal under a `role`. 
Hence we need to deploy an [AzureRole](/docs/concepts/secret-engine-crds/azure-secret-engine/azurerole.md) 
CRD before creating an `AzureAccessKeyRequest`.

```yaml
apiVersion: engine.kubevault.com/v1alpha1
kind: AzureAccessKeyRequest
metadata:
  name: <name>
  namespace: <namespace>
spec:
  ... ...
status: 
  ... ...
```

KubeVault operator performs the following operations when a AzureAccessKeyRequest CRD is created:

- Checks whether `status.conditions[].type` is `Approved` or not
- If Approved, makes request to the Vault server for credentials
- Creates a Kubernetes Secret which contains the credentials
- Sets the name of the k8s secret to GCPAccessKeyRequest's `status.secret`
- Assigns read permissions on that Kubernetes secret to specified subjects or user identities


## AzureAccessKeyRequest Spec

AzureAccessKeyRequest `Spec` contains information about [AzureRole](/docs/concepts/secret-engine-crds/azure-secret-engine/azurerole.md) and subjects.

```yaml
spec:
  roleRef:
    apiGroup: <role-apiGroup>
    kind: <role-kind>
    name: <role-name>
    namespace: <role-namespace>
  subjects:
    - kind: <subject-kind>
      apiGroup: <subject-apiGroup>
      name: <subject-name>
      namespace: <subject-namespace>
```

AzureAccessKeyRequest Spec has following fields:

### spec.roleRef

`spec.roleRef` is a `required` field that specifies the [AzureRole](/docs/concepts/secret-engine-crds/azure-secret-engine/azurerole.md) against which credential will be issued.

It has following field:
- `roleRef.apiGroup` : `optional`. Specifies the APIGroup of the resource being referenced.
- `roleRef.kind` : `optional`. Specifies the kind of the resource being referenced.
- `roleRef.name` : `Required`. Specifies the name of the object being referenced.
- `roleRef.namespace` : `Required`. Specifies the namespace of the referenced object.

```yaml
spec:
  roleRef:
    name: azure-role
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
## AzureAccessKeyRequest Status

`status` shows the status of the AzureAccessKeyRequest. It is maintained by KubeVault operator. It contains following fields:

- `secret` : Specifies the name of the secret containing Azure credential.

- `lease` : Contains lease information of the issued credential.

- `conditions` : Represent observations of a AzureAccessKeyRequest.

  ```yaml
  status:
    conditions:
      - type: Approved
  ```

  It has following field:

  - `conditions[].type` : `Required`. Specifies request approval state. Supported type: `Approved` and `Denied`.
  - `conditions[].reason` : `Optional`. Specifies brief reason for the request state.
  - `conditions[].message` : `Optional`. Specifies human readable message with details about the request state.

> Note: Azure credential will be issued if `conditions[].type` is `Approved`. Otherwise, KubeVault operator will not issue any credential.
