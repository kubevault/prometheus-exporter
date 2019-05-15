---
title: AzureRole | Vault Secret Engine
menu:
  docs_0.2.0:
    identifier: azurerole-secret-engine-crds
    name: AzureRole
    parent: secret-engine-crds-concepts
    weight: 10
menu_name: docs_0.2.0
section_menu_id: concepts
---

> New to KubeVault? Please start [here](/docs/concepts/README.md).

# AzureRole CRD

Most secrets engines must be configured in advance before they can perform their functions. When a AzureRole CRD is created, the vault operator will perform the following operations:

- [Enable](https://www.vaultproject.io/docs/secrets/azure/index.html#setup) the Vault Azure secret engine if it is not already enabled
- [Configure](https://www.vaultproject.io/api/secret/azure/index.html#configure-access) Vault Azure secret engine
- [Create](https://www.vaultproject.io/api/secret/azure/index.html#create-update-role) role according to `AzureRole` CRD specification


```yaml
apiVersion: engine.kubevault.com/v1alpha1
kind: AzureRole
metadata:
  name: <role-name>
  namespace: <role-namespace>
spec:
  authManagerRef:
    name: <appbinding-name>
    namespace: <appbinding-namespace>
  applicationObjectID: <application-object-id>
  config:
    subscriptionID: <subscription-id-for-AAD>
    tenantID: <tenant-id-for-AAD>
    clientID: <OAuth2-client-id>
    clientSecret: <OAuth2-client-secret>
  ttl: <ttl-time>
  maxTTL: <max-ttl-time>
status: ...
```

## AzureRole Spec

AzureRole `spec` contains information which will be required to enable and configure azure secret engine and finally create azure role.

```yaml
apiVersion: engine.kubevault.com/v1alpha1
kind: AzureRole
metadata:
  name: demo-role
  namespace: demo
spec:
  authManagerRef:
    name: vault-app
    namespace: demo
  applicationObjectID: c1cb042d-96d7-423a-8dba
  config:
    subscriptionID: 1bfc9f66-316d-433e-b13d
    tenantID: 772268e5-d940-4bf6-be82
    clientID: 2b871d4a-757e-4b2f-bc78
    clientSecret: azure-client-secret
    environment: AzurePublicCloud
  ttl: 1h
  maxTTL: 1h
```

### spec.authManagerRef

`spec.authManagerRef` specifies the name and namespace of [AppBinding](/docs/concepts/vault-server-crds/auth-methods/appbinding.md) that contains information to communicate with Vault.

```yaml
spec:
  authManagerRef:
    name: vault-app
    namespace: demo
```
### spec.applicationObjectID

Application Object ID for an existing service principal that will be used instead of creating dynamic service principals. If present, azure_roles will be ignored. See [roles docs](https://www.vaultproject.io/docs/secrets/azure/index.html#roles) for details on role definition.

```yaml
spec:
  applicationObjectID: c1cb042d-96d7-423a-8dba
```
### spec.config

`spec.config` is a required field that contains [information](https://www.vaultproject.io/api/secret/azure/index.html#configure-access) to communicate with Azure. It has the following fields:

- **subscriptionID**: `required`, The subscription id for the Azure Active Directory. 
- **tenantID**: `required`, The tenant id for the Azure Active Directory. 
- **clientID**: `optional`, The OAuth2 client id to connect to Azure.
- **clientSecret**: `optional`, The secret name that contains the OAuth2 client secret to connect to Azure in `data["clientSecret"]=<value>`
- **environment**: `optional`, The Azure environment. If not specified, Vault will use Azure Public Cloud.

```yaml
spec:
  config:
      subscriptionID: 1bfc9f66-316d-433e
      tenantID: 772268e5-d940-4bf6-be82
      clientID: 2b871d4a-757e-4b2f-bc78
      clientSecret: azure-client-secret
```

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: azure-client-secret
  namespace: demo
data:
  clientSecret: TU1hRjdRZWVzTGZxbGGJocz0= 
```

### spec.ttl

Specifies the default TTL for service principals generated using this role. Accepts time suffixed strings ("1h") or an integer number of seconds. Defaults to the system/engine default TTL time.

```yaml
spec:
  ttl: 1h
```

### spec.maxTTL

Specifies the maximum TTL for service principals generated using this role. Accepts time suffixed strings ("1h") or an integer number of seconds. Defaults to the system/engine max TTL time.

```yaml
spec:
  maxTTL: 1h
```

## AzureRole Status

`status` shows the status of the AzureRole. It is maintained by Vault operator. It contains following fields:

- `phase` : Indicates whether the role successfully applied in vault or not or in progress or failed

- `conditions` : Represent observations of a AzureRole.
