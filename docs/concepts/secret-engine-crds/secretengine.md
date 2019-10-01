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

