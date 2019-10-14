---
title: AzureRole | Vault Secret Engine
menu:
  docs_{{ .version }}:
    identifier: azurerole-secret-engine-crds
    name: AzureRole
    parent: secret-engine-crds-concepts
    weight: 10
menu_name: docs_{{ .version }}
section_menu_id: concepts
---

> New to KubeVault? Please start [here](/docs/concepts/README.md).

# AzureRole CRD

AzureRole [configures](https://www.vaultproject.io/docs/secrets/azure/index.html#setup) a Vault role.
A role may be set up with either an existing service principal, or a set of Azure roles that
will be assigned to a dynamically created service principal.

```yaml
apiVersion: engine.kubevault.com/v1alpha1
kind: AzureRole
metadata:
  name: <name>
  namespace: <namespace>
spec:
... ...
status:
... ...
```

> Note: To resolve the naming conflict, name of the role in Vault will follow this format: `k8s.{spec.clusterName}.{spec.namespace}.{spec.name}`

## AzureRole Spec

AzureRole `spec` contains either new service principal configuration or existing service principal name
required for configuring a role.

```yaml
spec:
  vaultRef:
    name: <appbinding-name>
  path: <azure-secret-engine-path>
  applicationObjectID: <existing-application-object-id>
  azureRoles: <list-of-azure-roles>
  ttl: <default-ttl>
  maxTTL: <max-ttl>
```

AzureRole Spec has following fields:

### spec.vaultRef

`spec.vaultRef` is a `required` field that specifies the name of [AppBinding](/docs/concepts/vault-server-crds/auth-methods/appbinding.md) that contains information to communicate with Vault.
 It is a local object reference that means AppBinding must be on the same namespace with AzureRole object. 

```yaml
spec:
  vaultRef:
    name: vault-app
```
### spec.path

`spec.path` is an `optional` field that specifies the path where the secret engine 
is enabled. The default path value is `azure`.

```yaml
spec:
  path: my-azure-path
```
### spec.azureRoles

`spec.azureRoles` is an `optional` field that specifies a list of Azure roles to be assigned 
to the generated service principal. The array must be in JSON format, properly escaped as a string. 

```yaml
spec:
  azureRoles: `[
                 {
                    "role_name": "Contributor",
                    "scope":  "/subscriptions/<uuid>/resourceGroups/Website"
                }
              ]`
```

### spec.applicationObjectID

`spec.applicationObjectID` is an `optional` field that specifies  the Application Object ID for 
an existing service principal that will be used instead of creating dynamic service principals. 
If present, azure_roles will be ignored. See [roles docs](https://www.vaultproject.io/docs/secrets/azure/index.html#roles) for details on role definition.

```yaml
spec:
  applicationObjectID: c1cb042d-96d7-423a-8dba-243c2e5010d3
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
