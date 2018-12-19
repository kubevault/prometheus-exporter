# PostgresRole CRD

Vault operator will create [database connection config](https://www.vaultproject.io/api/secret/databases/postgresql.html#configure-connection) and [role](https://www.vaultproject.io/api/secret/databases/index.html#create-role) according to `PostgresRole` CRD (CustomResourceDefinition) specification. If the user deletes the PostgresRole CRD, then respective role will also be deleted from Vault.

```yaml
apiVersion: authorization.kubedb.com/v1alpha1
kind: PostgresRole
metadata:
  name: <name>
  namespace: <namespace>
spec:
  ...
status:
  ...
```

> Note: To resolve the naming conflict, name of policy in Vault will follow this format: `k8s.{spec.clusterName}.{spec.namespace}.{spec.name}`

## PostgresRole Spec

PostgresRole `spec` contains policy and vault information.

```yaml
apiVersion: authorization.kubedb.com/v1alpha1
kind: PostgresRole
metadata:
  name: postgres-test
spec:
  creationStatements:
    - "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';"
    - "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";"
  defaultTTL: 300s
  maxTTL: 24h
  authManagerRef:
    type: vault
    namespace: default
    name: vault-app
  databaseRef:
    namespace: default
    name: postgres-app
```

PostgresRole Spec has following fields:

### spec.policy

`spec.policy` is a required field that specifies the vault policy in hcl format.

```yaml
spec:
  policy: |
      path "secret/*" {
        capabilities = ["create", "read", "update", "delete", "list"]
      }
```

### spec.vaultAppRef

`spec.vaultAppRef` is a required field that specifies name and namespace of [AppBinding](https://github.com/kmodules/custom-resources/blob/10b24c8fd9028ab67a4b75cbf16d8f8e52cfe634/apis/appcatalog/v1alpha1/appbinding_types.go#L21) that contains information to communicate with Vault.

```yaml
spec:
  vaultAppRef:
    name: vault
    namespace: demo
```

## PostgresRole Status

PostgresRole `status` shows the status of Vault Policy. It is maintained by Vault operator. It contains following fields:

- `status` : Indicates whether the policy successfully applied in vault or not or in progress or failed

- `conditions` : Represent observations of a PostgresRole.
