---
title: DatabaseAccessRequest | Vault Secret Engine
menu:
  docs_{{ .version }}:
    identifier: databaseaccessrequest-database-crds
    name: DatabaseAccessRequest
    parent: database-crds-concepts
    weight: 100
menu_name: docs_{{ .version }}
section_menu_id: concepts
---

> New to KubeVault? Please start [here](/docs/concepts/README.md).

![DatabaseAccessRequest CRD](/docs/images/concepts/database_accesskey_request.svg)

# DatabaseAccessRequest CRD

On deployment of DatabaseAccessRequest, the operator requests database credential from vault.
If `DatabaseAccessRequest` is approved, then KubeVault operator will issue credential from vault and 
create Kubernetes secret containing credential. The secret name will be specified in `status.secret.name` field.

```yaml
apiVersion: engine.kubevault.com/v1alpha1
kind: DatabaseAccessRequest
metadata:
  name: <name>
  namespace: <namespace>
spec:
  ... ...
status:
  ... ...
```

KubeVault operator performs the following operations when a DatabaseAccessRequest CRD is created:

- Checks whether `status.conditions[].type` is `Approved` or not
- If Approved, makes request to the Vault server for credentials
- Creates a Kubernetes Secret which contains the credentials
- Sets the name of the k8s secret to GCPAccessKeyRequest's `status.secret.name`
- Assigns read permissions on that Kubernetes secret to specified subjects or user identities

## DatabaseAccessRequest Spec

DatabaseAccessRequest `spec` contains information about database role and subject.

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
  ttl: <ttl-for-leases>
```

DatabaseAccessRequest Spec has following fields:

### spec.roleRef

`spec.roleRef` is a `required` field that specifies the reference of the database Role CRDs (i.e.[MongoDBRole](/docs/concepts/secret-engine-crds/database-secret-engine/mongodb.md), 
[PostgresRole](/docs/concepts/secret-engine-crds/database-secret-engine/postgresrole.md), 
[MySQLRole](/docs/concepts/secret-engine-crds/database-secret-engine/mysql.md)) 
against which credential will be issued.

It has following field:
- `roleRef.apiGroup` : `optional`. Specifies the APIGroup of the resource being referenced.
- `roleRef.kind` : `optional`. Specifies the kind of the resource being referenced.
- `roleRef.name` : `Required`. Specifies the name of the object being referenced.
- `roleRef.namespace` : `Required`. Specifies the namespace of the referenced object.

```yaml
spec:
  roleRef:
    name: database-role
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

### spec.ttl

`spec.ttl` is an optional field that specifies the TTL for the leases associated with this role. Accepts time suffixed strings ("1h") or an integer number of seconds. Defaults to roles default TTL time.

```yaml
spec:
  ttl: "1h"
```

## DatabaseAccessRequest Status

`status` shows the status of the DatabaseAccessRequest. It is managed by the KubeVault operator. It contains following fields:

- `secret` : Specifies the name of the secret containing database credential.

- `lease` : Contains lease information of the issued credential.

- `conditions` : Represent observations of a DatabaseAccessRequest.

    ```yaml
    status:
      conditions:
        - type: Approved
    ```

  It has following field:
  - `conditions[].type` : `Required`. Specifies request approval state. Supported type: `Approved` and `Denied`.
  - `conditions[].reason` : `Optional`. Specifies brief reason for the request state.
  - `conditions[].message` : `Optional`. Specifies human readable message with details about the request state.

> Note: Database credential will be issued if `conditions[].type` is `Approved`. Otherwise, KubeVault operator will not issue any credential.
