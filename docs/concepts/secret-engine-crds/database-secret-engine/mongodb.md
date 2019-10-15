---
title: MongoDBRole | Vault Secret Engine
menu:
  docs_{{ .version }}:
    identifier: mongodb-database-crds
    name: MongoDBRole
    parent: database-crds-concepts
    weight: 10
menu_name: docs_{{ .version }}
section_menu_id: concepts
---

> New to KubeVault? Please start [here](/docs/concepts/README.md).

# MongoDBRole CRD

On deployment of MongoDBRole, the operator creates a 
[role](https://www.vaultproject.io/api/secret/databases/index.html#create-role) according to the specification.
If the user deletes the `MongoDBRole` CRD, then respective role will also be deleted from Vault.

```yaml
apiVersion: engine.kubevault.com/v1alpha1
kind: MongoDBRole
metadata:
  name: <name>
  namespace: <namespace>
spec:
  ... ...
status:
  ... ...
```

> Note: To resolve the naming conflict, name of the role in Vault will follow this format: `k8s.{spec.clusterName}.{spec.namespace}.{spec.name}`

## MongoDBRole Spec

MongoDBRole `spec` contains information that necessary for creating database role.

```yaml
spec:
  vaultRef:
    name: <vault-appbinding-name>
  databaseRef:
    name: <database-appbinding-name>
    namespace: <database-appbinding-namespace>
  databaseName: <database-name>
  path: <secret-engine-path>
  defaultTTL: <default-ttl>
  maxTTL: <max-ttl>
  creationStatements:
    - "statement-0"
    - "statement-1"
  revocationStatements:
    - "statement-0"
```

MongoDBRole Spec has following fields:

### spec.vaultRef

`spec.vaultRef` is a `required` field that specifies the name of [AppBinding](/docs/concepts/vault-server-crds/auth-methods/appbinding.md) that contains information to communicate with Vault.
 It is a local object reference that means AppBinding must be on the same namespace with AWSRole object. 

```yaml
spec:
  vaultRef:
    name: vault-app
```

### spec.databaseRef

`spec.databaseRef` is an `optional` field that specifies the reference of [AppBinding](/docs/concepts/vault-server-crds/auth-methods/appbinding.md)
that contains mongodb database connection information. It is used to generate the `db_name`. The operator follows the naming format 
for `db_name` while configuring database secret engine: `k8s.{cluster-name}.{namespace}.{name}`. 

```yaml
spec:
  databaseRef:
    name: mongodb-app
    namespace: demo
```

### spec.databaseName 

`spec.databaseName` is an `optional` field that specifies the `db_name`. It is used when `spec.databaseRef` is empty otherwise ignored. 
Both `spec.databaseRef` and `spec.databaseName` cannot be empty at a time.

```yaml
spec:
  databaseName: k8s.-.demo.mongodb-app
```

### spec.path

`spec.path` is an `optional` field that specifies the path where the secret engine 
is enabled. The default path value is `database`.

```yaml
spec:
  path: my-mongodb-path
```

### spec.creationStatements

`spec.creationStatements` is a `required` field that specifies a list of database statement executed to create and configure a user. 
See in [here](https://www.vaultproject.io/api/secret/databases/mongodb.html#creation_statements) for Vault documentation.

```yaml
spec:
  creationStatements:
    - "{ \"db\": \"admin\", \"roles\": [{ \"role\": \"readWrite\" }, {\"role\": \"read\", \"db\": \"foo\"}] }"
```

### spec.defaultTTL

`spec.defaultTTL` is an `optional` field that specifies the TTL for the leases associated with this role.
Accepts time suffixed strings ("1h") or an integer number of seconds.
 Defaults to system/engine default TTL time.

```yaml
spec:
  defaultTTL: "1h"
```

### spec.maxTTL

`spec.maxTTL` is an `optional` field that specifies the maximum TTL for the leases 
associated with this role. Accepts time suffixed strings ("1h") or an integer number of seconds. 
Defaults to system/engine default TTL time.

```yaml
spec:
  maxTTL: "1h"
```

### spec.revocationStatements

`spec.revocationStatements` is an `optional` field that specifies 
a list of database statement to be executed to revoke a user. 
See in [here](https://www.vaultproject.io/api/secret/databases/mongodb.html#revocation_statements) 
for Vault documentation.

## MongoDBRole Status

`status` shows the status of the MongoDBRole. It is maintained by Vault operator. It contains following fields:

- `status` : Indicates whether the role successfully applied in vault or not or in progress or failed

- `conditions` : Represent observations of a MongoDBRole.
