---
title: Secret Engine
menu:
  docs_{{ .version }}:
    identifier: secret-engine-crds
    name: SecretEngine
    parent: secret-engine-crds-concepts
    weight: 10
menu_name: docs_{{ .version }}
section_menu_id: concepts
---

> New to KubeVault? Please start [here](/docs/concepts/README.md).

# Secret Engines

Secrets engines are components which store, generate, 
or encrypt data. Secrets engines are provided some set of data, 
they take some action on that data, and they return a result. 
Secrets engines are enabled at a "path" in Vault. 
In this way, each secrets engine defines its own paths and properties. 
To the user, secrets engines behave similar to a virtual filesystem,
supporting operations like read, write, and delete.

For more details visit [Vault official documentation](https://www.vaultproject.io/docs/secrets/)

# Secret Engine CRD

`SecretEngine` is a kubernetes [Custom Resource Definition](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/#customresourcedefinitions) designed to automate the process of enabling and configuring secret engines. 
When a `SecretEngine` CRD is created, the vault operator will perform the following operations:

- **Creates** vault policy for the secret engine.
- **Binds** the policy to the default k8s service account created with `VaultServer` 
- **Enables** the secrets engine at a given path. By default, they are enabled at their "type" (e.g. "aws" enables at "aws/").
- **Configures** the secret engine with given configuration.

```yaml
apiVersion: engine.kubevault.com/v1alpha1
kind: SecretEngine
metadata:
  name: <secret-engine-name>
spec:
... ... ...
```
## SecretEngine Spec
SecretEngine `.spec` contains information about the secret engine configuration
and the [AppBinding](/docs/concepts/vault-server-crds/auth-methods/appbinding.md) reference which is used to connect vault server. 

Sample SecretEngine yaml:
```yaml
apiVersion: engine.kubevault.com/v1alpha1
kind: SecretEngine
metadata:
  name: first-secret-engine
  namespace: demo
spec:
  vaultRef:
    name: vault
  gcp:
    credentialSecret: "gcp-cred"
```
---
SecretEngine `.spec` has the following fields:

### spec.vaultRef

`spec.vaultRef` is a `required` field that specifies the [AppBinding](/docs/concepts/vault-server-crds/auth-methods/appbinding.md)
reference which is used to connect vault server. It's a `LocalObjectReference` that means
the AppBinding must be on the same namespace of the secret engine crd.  

```yaml
spec:
  vaultRef:
    name: vault
```
### spec.path

`spec.path` is an `optional` field that specifies the path where the secret engine 
will be enabled. The default path values are:
- GCP secret engine: `gcp`
- AWS secret engine: `aws`
- Azure secret engine: `azure`
- Database secret engine: `database`

```yaml
spec:
  path: my-path
```
### spec.aws

`spec.aws` specifies the configuration required to configure 
aws secret engine. [See more](https://www.vaultproject.io/api/secret/aws/index.html#parameters)

```yaml
spec:
  aws:
    credentialSecret: aws-cred
    region: us-east-1
    leaseConfig:
      lease: 1h
      leaseMax: 1h
```

- `aws.credentialSecret` : `Required`. Specifies the k8s secret name that contains AWS access key ID and secret access key
    ```yaml
    spec:
      aws:
        credentialSecret: <secret-name>
    ```
    where `data` field of the secret must contain the following key-value pairs: 
    ```yaml
    data:
      access_kay: <access key>
      secret_key: <secret key>
    ```
- `aws.region` : `Required`. Specifies the AWS region.

- `aws.iamEndpoint` : `Optional`. Specifies a custom HTTP IAM endpoint to use.

- `aws.stsEndpoint` : `Optional`. Specifies a custom HTTP STS endpoint to use.

- `config.maxRetries` : `Optional`. Specifies the number of max retries the client should use for recoverable errors.

- `aws.leaseConfig` : `Optional`. Specifies the lease configuration.

    ```yaml
    config:
      leaseConfig:
        lease: 1h
        leaseMax: 1h
    ```

    It has following fields:
    - `leaseConfig.lease` : `Optional`. Specifies the lease value. Accepts time suffixed strings ("1h").
    - `leaseConfig.leaseMax` : `Optional`. Specifies the maximum lease value. Accepts time suffixed strings ("1h").

### spec.azure

`spec.azure` specifies the configuration that is required for the plugin
 to perform API calls to Azure. [See more](https://www.vaultproject.io/api/secret/azure/index.html#configure-access)

```yaml
spec:
  config:
    credentialSecret: azure-cred
    environment: AzurePublicCloud
```
- `credentialSecret` : `required`. Specifies the k8s secret name containing azure credentials.
    - `subscription-id` : `required`. Specifies the subscription id for the Azure Active Directory.
    - `tenant-id` : `required`. Specifies the tenant id for the Azure Active Directory.
    - `client-id` : `optional`. Specifies the OAuth2 client id to connect to Azure.
    - `client-secret` : `optional`. Specifies the OAuth2 client secret to connect to Azure.
    
    ```yaml
    data:
      subscription-id: <value>
      tenant-id: <value>
      client-id: <value>
      client-secret: <value>
    ```
- `environment` : `optional`. Specifies the Azure environment. If not specified, Vault will use Azure Public Cloud.


### spec.gcp

`spec.gcp` specifies the [configuration](https://www.vaultproject.io/api/secret/gcp/index.html#write-config) required to configure gcp 
secret engine so that vault can communicate with GCP.
 It has the following fields:

```yaml
spec:
  gcp:
    credentialSecret: gcp-cred
    ttl: 0s
    maxTTL: 0s
```

- `credentialSecret` : `required`. Specifies the k8s secret name that contains google application credentials.
  ```yaml
  spec:
    gcp:
      credentialSecret: <secret-name>  
  ```
  The `data` field of the mentioned k8s secret must contain the following key-value pair:
  
  ```yaml
  data:
    sa.json: <google-application-credential>
  ```
- `ttl` : `optional`. Specifies default config TTL for long-lived credentials (i.e. service account keys). Default value is 0s.
- `maxTTL` : `optional`. Specifies the maximum config TTL for long-lived credentials (i.e. service account keys). Default value is 0s.

### spec.postgres

`spec.postgres` 





        
    