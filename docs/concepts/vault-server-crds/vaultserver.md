# VaultServer CRD

Vault operator will deploy Vault according to `VaultServer` CRD (CustomResourceDefinition) specification.

```yaml
apiVersion: kubevault.com/v1alpha1
kind: VaultServer
metadata:
  name: <name>
spec:
  ...
status:
  ...
```

## VaultServer Spec

VaultServer Spec contains the configuration about how to deploy Vault in Kubernetes cluster. It also covers automate unsealing of Vault.

```yaml
apiVersion: kubevault.com/v1alpha1
kind: VaultServer
metadata:
  name: example
  namespace: default
spec:
  nodes: 1
  version: "0.11.1"
  backend:
    inmem: {}
  unsealer:
    secretShares: 4
    secretThreshold: 2
    insecureSkipTLSVerify: true
    mode:
      kubernetesSecret:
        secretName: vault-keys
```

The `spec` section has following parts:

### spec.nodes 

`spec.nodes` specifies the number of vault nodes to deploy. It has to be a positive number.

```yaml
spec:
  nodes: 3 # 3 vault server will be deployed in kubernetes cluster
```

### spec.version

Specifies the name of the `VaultServerVersion` CRD. This CRD holds the image name and version of the Vault, Unsealer and Exporter. To know more information about `VaultServerVersion` CRD see [here](/docs/concepts/vault-server-crds/vaultserverversion.md).

```yaml
spec:
  version: "1.0.0"
```

### spec.tls

`spec.tls` is an optional field that specifies TLS policy of Vault nodes. If this is not specified, Vault operator will auto generate TLS assets and secrets.

```yaml
spec:
  tls:
    tlsSecret: <tls_assets_secret_name> # name of the secret containing TLS assets
```

- **`tls.tlsSecret`**: Specifies the name of the secret containing TLS assets. The secret must contain following keys:
  - `ca.crt`
  - `server.crt`
  - `server.key`

  The server certificate must allow the following wildcard domains:
  - `localhost`
  - `*.<namespace>.pod`
  - `<vaultServer-name>.<namespace>.svc`

### spec.configSource

`spec.configSource` is an optional field that allows the user to provide extra configuration for Vault. This field accepts a [VolumeSource](https://github.com/kubernetes/api/blob/release-1.11/core/v1/types.go#L47). You can use any kubernetes supported volume source such as configMap, secret, azureDisk etc.

> Please note that the config file name needs to be `vault.hcl` for Vault.

### spec.backend

`spec.backend` is a required field that specifies Vault backend storage configuration. Vault operator generates storage configuration according to this `spec.backend`.

```yaml
spec:
  backend:
    ...
```

List of supported backends:

- [Azure](/docs/concepts/vault-server-crds/storage/azure.md)
- [S3](/docs/concepts/vault-server-crds/storage/s3.md)
- [GCS](/docs/concepts/vault-server-crds/storage/gcs.md)
- [DynamoDB](/docs/concepts/vault-server-crds/storage/dynamodb.md)
- [PosgreSQL](/docs/concepts/vault-server-crds/storage/postgresql.md)
- [MySQL](/docs/concepts/vault-server-crds/storage/mysql.md)
- [In Memory](/docs/concepts/vault-server-crds/storage/inmem.md)
- [Swift](/docs/concepts/vault-server-crds/storage/swift.md)

### spec.unsealer

`spec.unsealer` is an optional field that specifies [Unsealer](https://github.com/kubevault/unsealer) configuration. Unsealer handles automatic initializing and unsealing of Vault. See [here](/docs/concepts/vault-server-crds/unsealer/unsealer.md) for Unsealer fields information.

```yaml
spec:
  unsealer:
    secretShares: <num_of_secret_shares>
    secretThresold: <num_of_secret_threshold>
    retryPeriodSeconds: <retry_period>
    overwriteExisting: <true/false>
    insecureSkipTLSVerify: <true/false>
    caBundle: <pem_encoded_ca_cert>
    mode:
      ...
```
