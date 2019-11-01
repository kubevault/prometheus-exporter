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
When a `SecretEngine` CRD is created, the KubeVault operator will perform the following operations:

- **Creates** vault policy for the secret engine. The vault policy name follows the naming format:`k8s.{clusterName}.{namespace}.{name}`. The policy for gcp secret engine:
    ```yaml
    path "<path>/config" {
	    capabilities = ["create", "update", "read", "delete"]
    }
    
    path "<path>/roleset/*" {
        capabilities = ["create", "update", "read", "delete"]
    }
    
    path "<path>/token/*" {
        capabilities = ["create", "update", "read"]
    }
    
    path "<path>/key/*" {
        capabilities = ["create", "update", "read"]
    }
    ```
- **Updates** the kubernetes auth role of the default k8s service account created with `VaultServer` with new policy. The new policy will be merged with previous policies.
- **Enables** the secrets engine at a given path. By default, they are enabled at their "type" (e.g. "aws" enables at "aws/").
- **Configures** the secret engine with given configuration.

```yaml
apiVersion: engine.kubevault.com/v1alpha1
kind: SecretEngine
metadata:
  name: <secret-engine-name>
spec:
... ...
status:
... ...
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


---
Secret engines are enabled at a "path" in Vault. When a request comes to Vault, 
the router automatically routes anything with the route prefix to the secrets engine. 
Since operator configures a secret engine to a specified path with SecretEngine crd,
you can provide **only one secret engine configuration** out of the followings:

- `spec.aws` : Specifies aws secret engine configuration
- `spec.azure`: Specifies azure secret engine configuration
- `spec.gcp`: Specifies gcp secret engine configuration
- `spec.postgres`: Specifies database(postgres) secret engine configuration
- `spec.mongodb`: Specifies database(mongodb) secret engine configuration
- `spec.mysql`: Specifies database(mysql) secret engine configuration
    
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
  azure:
    credentialSecret: azure-cred
    environment: AzurePublicCloud
```
- `credentialSecret` : `required`. Specifies the k8s secret name containing azure credentials.
    - `subscription-id` : `required`. Specifies the subscription id for the Azure Active Directory.
    - `tenant-id` : `required`. Specifies the tenant id for the Azure Active Directory.
    - `client-id` : `optional`. Specifies the OAuth2 client id to connect to Azure.
    - `client-secret` : `optional`. Specifies the OAuth2 client secret to connect to Azure.
    
    The `data` field of the mentioned k8s secret can have the following key-value pairs.
    ```yaml
    data:
      subscription-id: <value>
      tenant-id: <value>
      client-id: <value>
      client-secret: <value>
    ```
- `environment` : `optional`. Specifies the Azure environment. If not specified, Vault will use Azure Public Cloud.


### spec.gcp

`spec.gcp` specifies the configuration required to configure gcp 
secret engine so that vault can communicate with GCP. [See more](https://www.vaultproject.io/api/secret/gcp/index.html#write-config)

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

`spec.postgres` specifies the configuration that is required for vault
 to perform API calls to Postgres database. [See more](https://www.vaultproject.io/api/secret/databases/postgresql.html#configure-connection)
 
 ```yaml
  spec:
    postgres:
      databaseRef:
        name: <appbinding-name>
        namespace: <appbinding-namespace>
      pluginName: <plugin-name>
      allowedRoles:
        - "rule1"
        - "rule2"
      maxOpenConnections: <max-open-connection>
      maxIdleConnections: <max-idle-connection>
      maxConnectionLifetime: <max-connection-lifetime>
 ```
- `databaseRef` : `required`. Specifies the [AppBinding](/docs/concepts/vault-server-crds/auth-methods/appbinding.md) reference that is 
    required to connect postgres database. It is also used to generate `db_name` (i.e. `/v1/path/config/db_name`) where the database secret
    engine will be configured at. The naming of `db_name` follows: `k8s.{cluster-name}.{namespace}.{name}`. 
    - `name` : `required`. Specifies the AppBinding name.
    - `namespace` : `required`. Specifies the AppBinding namespace.
    ```yaml
    postgres:    
      databaseRef:
        name: db-app
        namespace: demo
    ```
    The generated `db_name` for the above example will be: `k8s.-.demo.db-app`. If cluster name is empty, it is replaced by "`-`".

- `pluginName` : `optional`. Specifies the name of the plugin to use for this connection.
    Default plugin name is `postgres-database-plugin`. 
    ```yaml
    postgres:
      pluginName: postgres-database-plugin
    ```

- `allowedRoles` : `optional`. Specifies a list of roles allowed to use this connection.
    Default to `"*"` (i.e. any role can use this connection). 
    ```yaml
    postgres:
      allowedRoles:
        - "readonly"
    ```
    
- `maxOpenConnections` : `optional`. Specifies the maximum number of open connections to 
    the database. Default value 2.
    ```yaml
    postgres:
      maxOpenConnections: 3
    ```
    
- `maxIdleConnections` : `optional`.  Specifies the maximum number of idle connections to
    the database. A zero uses the value of max_open_connections and a negative
    value disables idle connections. If larger than max_open_connections it will be 
    reduced to be equal. Default value 0.
    ```yaml
    postgres:
      maxIdleConnections: 1
    ```


- `maxConnectionLifetime` : `optional`. Specifies the maximum amount of time a 
    connection may be reused. If <= 0s connections are reused forever. Default value 0s.
    ```yaml
    postgres:
      maxConnectionLifetime: 5s
    ```

### spec.mongodb

`spec.mongodb` specifies the configuration that is required for vault
 to perform API calls to mongodb database. [See more](https://www.vaultproject.io/api/secret/databases/mongodb.html#configure-connection)

```yaml
  spec:
    mongodb:
      databaseRef:
        name: <appbinding-name>
        namespace: <namespace>
      pluginName: <plugin-name>
      allowedRoles:
        - "role1"
        - "role2"
      writeConcern: <write-concern>
```

- `databaseRef` : `required`. Specifies the [AppBinding](/docs/concepts/vault-server-crds/auth-methods/appbinding.md) reference that is 
    required to connect mongodb database. It is also used to generate `db_name` (i.e. `/v1/path/config/db_name`) where the database secret
    engine will be configured at. The naming of `db_name` follows: `k8s.{cluster-name}.{namespace}.{name}`. 
    - `name` : `required`. Specifies the AppBinding name.
    - `namespace` : `required`. Specifies the AppBinding namespace.
    ```yaml
    mongodb:    
      databaseRef:
        name: db-app
        namespace: demo
    ```
    The generated `db_name` for the above example will be: `k8s.-.demo.db-app`. If cluster name is empty, it is replaced by "`-`".

- `pluginName` : `optional`. Specifies the name of the plugin to use for this connection.
    Default plugin name is `mongodb-database-plugin`. 
    
    ```yaml
    mongodb:
      pluginName: mongodb-database-plugin
    ```

- `allowedRoles` : `optional`. Specifies a list of roles allowed to use this connection.
    Default to `"*"` (i.e. any role can use this connection). 
    ```yaml
    mongodb:
      allowedRoles:
        - "readonly"
    ```
    
- `writeConcern` : `optional`. Specifies the MongoDB write concern.
    This is set for the entirety of the session, maintained for the lifecycle
    of the plugin process. Must be a serialized JSON object, 
    or a base64-encoded serialized JSON object. The JSON payload values map 
    to the values in the Safe struct from the mgo driver.
    ```yaml
    mongodb:
      writeConcern: `{ \"wmode\": \"majority\", \"wtimeout\": 5000 }`
    ```
    
### spec.mysql

`spec.mysql` specifies the configuration that is required for vault
 to perform API calls to mysql database. [See more](https://www.vaultproject.io/api/secret/databases/mysql-maria.html#configure-connection)
 
```yaml
spec:
  mysql:
    databaseRef:
      name: <appbinding-name>
      namespace: <appbinding-namespace>
    pluginName: <plugin-name>
    allowedRoles:
      - "role1"
      - "role2"
      - ... ...
    maxOpenConnections: <max-open-connections>
    maxIdleConnections: <max-idle-connections>
    maxConnectionLifetime: <max-connection-lifetime>
```

- `databaseRef` : `required`. Specifies the [AppBinding](/docs/concepts/vault-server-crds/auth-methods/appbinding.md) reference that is 
    required to connect mysql database. It is also used to generate `db_name` (i.e. `/v1/path/config/db_name`) where the database secret
    engine will be configured at. The naming of `db_name` follows: `k8s.{cluster-name}.{namespace}.{name}`. 
    - `name` : `required`. Specifies the AppBinding name.
    - `namespace` : `required`. Specifies the AppBinding namespace.
    ```yaml
    mysql:    
      databaseRef:
        name: db-app
        namespace: demo
    ```
    The generated `db_name` for the above example will be: `k8s.-.demo.db-app`. If cluster name is empty, it is replaced by "`-`".

- `pluginName` : `optional`. Specifies the name of the plugin to use for this connection.
    Default plugin name is `mysql-database-plugin`. 
    ```yaml
    mysql:
      pluginName: mysql-database-plugin
    ```

- `allowedRoles` : `optional`. Specifies a list of roles allowed to use this connection.
    Default to `"*"` (i.e. any role can use this connection). 
    ```yaml
    mysql:
      allowedRoles:
        - "readonly"
    ```
    
- `maxOpenConnections` : `optional`. Specifies the maximum number of open connections to 
    the database. Default value 2.
    ```yaml
    mysql:
      maxOpenConnections: 3
    ```
    
- `maxIdleConnections` : `optional`.  Specifies the maximum number of idle connections to
    the database. A zero uses the value of max_open_connections and a negative
    value disables idle connections. If larger than max_open_connections it will be 
    reduced to be equal. Default value 0.
    ```yaml
    mysql:
      maxIdleConnections: 1
    ```


- `maxConnectionLifetime` : `optional`. Specifies the maximum amount of time a 
    connection may be reused. If <= 0s connections are reused forever. Default value 0s.
    ```yaml
    mysql:
      maxConnectionLifetime: 5s
    ```

## SecretEngine Status

`status` shows the status of the SecretEngine. It is managed by the KubeVault operator. It contains following fields:

- `observedGeneration`: Specifies the most recent generation observed for this resource. It corresponds to the resource's generation, 
    which is updated on mutation by the API Server.
    
- `phase` : Indicates whether the secret engine successfully configured in vault or not or in progress or failed

- `conditions` : Represent observations of a SecretEngine.

    