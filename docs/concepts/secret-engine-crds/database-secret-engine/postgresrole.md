---
title: PostgresRole | Vault Secret Engine
menu:
  docs_{{ .version }}:
    identifier: postgresrole-database-crds
    name: PostgresRole
    parent: database-crds-concepts
    weight: 20
menu_name: docs_{{ .version }}
section_menu_id: concepts
---

> New to KubeVault? Please start [here](/docs/concepts/README.md).

# PostgresRole CRD

On deployment of PostgresRole, the operator creates a [role](https://www.vaultproject.io/api/secret/databases/index.html#create-role) according to specification.
If the user deletes the `PostgresRole` CRD, then respective role will also be deleted from Vault.

```yaml
apiVersion: authorization.kubedb.com/v1alpha1
kind: PostgresRole
metadata:
  name: <name>
  namespace: <namespace>
spec:
  ... ...
status:
  ... ...
```

> Note: To resolve the naming conflict, name of the role in Vault will follow this format: `k8s.{spec.clusterName}.{spec.namespace}.{spec.name}`

## PostgresRole Spec

PostgresRole `spec` contains information that necessary for creating database config and role.

```yaml
spec:
  vaultRef:
    name: <vault-appbinding-name>
  databaseRef:
    name: <database-appbinding-name>
    namespace: <database-appbinding-namespace>
  path: <database-secret-engine-path>
  defaultTTL: <default-ttl>
  maxTTL: <max-ttl>
  creationStatements:
    - "statement-0"
    - "statement-1"
  revocationStatements:
    - "statement-0"
  rollbackStatements:
    - "statement-0"
  renewStatements:
    - "statement-0"
```

PostgresRole Spec has following fields:

### spec.vaultRef

`spec.vaultRef` is a `required` field that specifies the name of [AppBinding](/docs/concepts/vault-server-crds/auth-methods/appbinding.md) that contains information to communicate with Vault.
 It is a local object reference that means AppBinding must be on the same namespace with AWSRole object. 

```yaml
spec:
  vaultRef:
    name: vault-app
```

### spec.databaseRef

`spec.databaseRef` is a `required` field that specifies the reference of [AppBinding](/docs/concepts/vault-server-crds/auth-methods/appbinding.md)
that contains Postgres database connection information.

```yaml
spec:
  databaseRef:
    name: postgres-app
    namespace: demo
```

### spec.creationStatements

`spec.creationStatements` is a `required` field that specifies a list of database statement executed to create and configure a user.
The `{{name}}`, `{{password}}` and `{{expiration}}` values will be substituted by Vault.

```yaml
spec:
  creationStatements:
    - "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';"
    - "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";"
```

### spec.defaultTTL

`spec.defaultTTL` is an `optional` field that specifies the TTL for the leases associated with this role.
Accepts time suffixed strings ("1h") or an integer number of seconds. Defaults to system/engine default TTL time.

```yaml
spec:
  defaultTTL: "1h"
```

### spec.maxTTL

`spec.maxTTL` is an `optional` field that specifies the maximum TTL for the leases associated with this role. 
Accepts time suffixed strings ("1h") or an integer number of seconds. Defaults to system/engine default TTL time.

```yaml
spec:
  maxTTL: "1h"
```

### spec.revocationStatements

`spec.revocationStatements` is an `optional` field that specifies a list of  database statement to be executed
 to revoke a user. The `{{name}}` value will be substituted. If not provided defaults to a generic drop user statement.

### spec.rollbackStatements

`spec.rollbackStatements` is an `optional` field that specifies a list of  database statement to be executed 
rollback a create operation in the event of an error. Not every plugin type will support this functionality.

### spec.renewStatements

`spec.renewStatements` is an `optional` field that specifies a list of database statement to be executed
 to renew a user. Not every plugin type will support this functionality.

## PostgresRole Status

`status` shows the status of the PostgresRole. It is maintained by Vault operator. It contains following fields:

- `status` : Indicates whether the role successfully applied in vault or not or in progress or failed

- `conditions` : Represent observations of a PostgresRole.
