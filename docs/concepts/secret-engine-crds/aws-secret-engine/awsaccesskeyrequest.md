---
title: AWSAccessKeyRequest | Vault Secret Engine
menu:
  docs_{{ .version }}:
    identifier: awsaccesskeyrequest-secret-engine-crds
    name: AWSAccessKeyRequest
    parent: secret-engine-crds-concepts
    weight: 15
menu_name: docs_{{ .version }}
section_menu_id: concepts
---

> New to KubeVault? Please start [here](/docs/concepts/README.md).

# AWSAccessKeyRequest

## What is AWSAccessKeyRequest

An `AWSAccessKeyRequest` is a Kubernetes `CustomResourceDefinition`(CRD) which allows a user to request the Vault for AWS credentials in a Kubernetes native way.
If `AWSAccessKeyRequest` is approved, then the KubeVault operator will issue credential from Vault and
create Kubernetes secret containing credential. The secret name will be specified in `status.secret.name` field.
The operator will also create `ClusterRole` and `ClusterRoleBinding` for the k8s secret.

![AWSAccessKeyRequest CRD](/docs/images/concepts/aws_accesskey_request.svg)

KubeVault operator performs the following operations when an AWSAccessKeyRequest CRD is created:

- Checks whether `status.conditions[].type` is `Approved` or not
- If Approved, makes GCP access key request to vault
- Creates a Kubernetes Secret which contains the GCP secrets
- Sets the name of the k8s secret to GCPAccessKeyRequest's `status.secret`
- Provides permissions of Kubernetes secret to specified objects or user identities

## AWSAccessKeyRequest CRD Specification

Like any official Kubernetes resource, a `AWSAccessKeyRequest` object has `TypeMeta`, `ObjectMeta`, `Spec` and `Status` sections.

A sample `AWSAccessKeyRequest` object is shown below:

```yaml
apiVersion: engine.kubevault.com/v1alpha1
kind: AWSAccessKeyRequest
metadata:
  name: aws-cred-req
  namespace: demo
spec:
  roleRef:
    name: aws-role
    namespace: demo
  subjects:
    - kind: ServiceAccount
      name: sa
      namespace: demo
status:
  ... ...
```

Here, we are going to describe the various sections of the `AWSAccessKeyRequest` crd.

### AWSAccessKeyRequest Spec

AWSAccessKeyRequest `spec` contains information about AWS role and subject.

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
  roleARN: <ARN-of-role>
  ttl: <ttl-for-STS-token>
  useSTS: <boolean-value>
```

AWSAccessKeyRequest Spec has following fields:

#### spec.roleRef

`spec.roleRef` is a `required` field that specifies the [AWSRole](/docs/concepts/secret-engine-crds/aws-secret-engine/awsrole.md) against which credential will be issued.

It has the following fields:

- `roleRef.apiGroup` : `optional`. Specifies the APIGroup of the resource being referenced.

- `roleRef.kind` : `optional`. Specifies the kind of the resource being referenced.

- `roleRef.name` : `Required`. Specifies the name of the object being referenced.

- `roleRef.namespace` : `Required`. Specifies the namespace of the referenced object.

```yaml
spec:
  roleRef:
    name: aws-role
    namespace: demo
```

#### spec.subjects

`spec.subjects` is a `required` field that contains a list of references to the object or
user identities where the `RoleBinding` applies to. These object or user identities will have
read access to the k8s credential secret. This can either hold a direct API object reference or a value for non-objects such as user and group names.

It has the following fields:

- `kind` : `required`. Specifies the kind of object being referenced. Values   defined by
  these API groups are "User", "Group", and "ServiceAccount". If the Authorizer does not
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

#### spec.roleARN

`spec.roleARN` is an `optional` field that specifies the ARN of the role to
 assume if `credential_type` on the Vault role is `assumed_role`.
 Must match one of the allowed role ARNs in the Vault role.
 Optional if the Vault role only allows a single AWS role ARN, required otherwise.

```yaml
spec:
  roleARN: "arn:aws:iam::452618475015:role/hello.world"
```

#### spec.ttl

`spec.ttl` is an `optional` field that specifies the TTL for the use
of the STS token. This is specified as a string with a duration suffix.

```yaml
spec:
  ttl: "1h"
```

#### spec.useSTS

`spec.useSTS` is an `optional` field. If this is `true`, `/aws/sts` endpoint will be used to retrieve credential.
 Otherwise, `/aws/creds` endpoint will be used to retrieve credentials.

```yaml
spec:
  useSTS: true
```

### AWSAccessKeyRequest Status

`status` shows the status of the AWSAccessKeyRequest. It is managed by the KubeVault operator. It contains the following fields:

- `secret`: Specifies the name of the secret containing AWS credential.

- `lease`: Contains lease information of the issued credential.

- `conditions` : Represent observations of a AWSAccessKeyRequest.

    ```yaml
    status:
      conditions:
        - type: Approved
    ```

  It has following field:
  - `conditions[].type` : `Required`. Specifies request approval state. Supported type: `Approved` and `Denied`.
  - `conditions[].reason` : `Optional`. Specifies brief reason for the request state.
  - `conditions[].message` : `Optional`. Specifies human readable message with details about the request state.

> Note: AWS credential will be issued if `conditions[].type` is `Approved`. Otherwise, the KubeVault operator will not issue any credentials.
