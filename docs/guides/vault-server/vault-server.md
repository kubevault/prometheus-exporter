---
title: Vault Server
menu:
  docs_{{ .version }}:
    identifier: vault-server
    name: Vault Server
    parent: vault-server-guides
    weight: 10
menu_name: docs_{{ .version }}
section_menu_id: guides
---

> New to KubeVault? Please start [here](/docs/concepts/README.md).

Before you begin:

- Install KubeVault operator in your cluster following the steps [here](/docs/setup/operator/install.md).

---

![Vault Server](/docs/images/guides/vault-server/vault_server.svg)

## Deploy Vault

You can easily deploy and manage [HashiCorp's Vault](https://www.vaultproject.io/) in Kubernetes cluster
using KubeVault operator. In this tutorial, we are going to deploy Vault on Kubernetes cluster using KubeVault operator.

To start with this tutorial, you need to be familiar with the following CRDs:
- [AppBinding](/docs/concepts/vault-server-crds/auth-methods/appbinding.md)
- [VaultServerVersion](/docs/concepts/vault-server-crds/vaultserverversion.md)
- [VaultServer](/docs/concepts/vault-server-crds/vaultserver.md)

To keep things isolated, we are going to use a separate namespace called `demo` throughout this tutorial.

```console
$ kubectl create ns demo
namespace/demo created
```
### Deploy VaultServerVersion

By installing KubeVault operator, you have already deployed some VaultServerVersion crds named after
the Vault image tag its using. You can list them by using the following command:

```console
$ kubectl get vaultserverversions
NAME    VERSION   VAULT_IMAGE   DEPRECATED   AGE
1.2.0   1.2.0     vault:1.2.0   false        38s
1.2.2   1.2.2     vault:1.2.2   false        38s
1.2.3   1.2.3     vault:1.2.3   false        38s
```
Now you can use them or deploy your own version by yourself:

```yaml
apiVersion: catalog.kubevault.com/v1alpha1
kind: VaultServerVersion
metadata:
  name: 1.2.1
spec:
  vault:
    image: vault:1.2.1
  exporter:
    image: kubevault/vault-exporter:0.1.0
  unsealer:
    image: kubevault/vault-unsealer:v0.3.0
  version: 1.2.1
```
Deploy VaultServerVersion `1.2.1`:

```console
$ kubectl apply -f https://raw.githubusercontent.com/kubevault/docs/master/docs/examples/guides/vault-server/vaultserverversion.yaml
vaultserverversion.catalog.kubevault.com/1.2.1 created
```

### Deploy VaultServer

Once you have deployed VaultServerVersion, you are ready to deploy VaultServer.

```yaml
apiVersion: kubevault.com/v1alpha1
kind: VaultServer
metadata:
  name: vault
  namespace: demo
spec:
  nodes: 1
  version: "1.2.3"
  serviceTemplate:
    spec:
      type: NodePort
  backend:
    inmem: {}
  unsealer:
    secretShares: 4
    secretThreshold: 2
    mode:
      kubernetesSecret:
        secretName: vault-keys
```
For more information about supported **backend** and **unsealer option** visit `VaultServer` CRD [documentation](/docs/concepts/vault-server-crds/vaultserver.md)

Deploy `VaultServer`:

```console
$ kubectl apply -f https://raw.githubusercontent.com/kubevault/docs/master/docs/examples/guides/vault-server/vaultserver.yaml
vaultserver.kubevault.com/vault created
```
Check VaultServer status:

```console
$ kubectl get vaultserver -n demo
NAME    NODES   VERSION   STATUS       AGE
vault   1       1.2.3     Processing   47s
$ kubectl get vaultserver -n demo
NAME    NODES   VERSION   STATUS   AGE
vault   1       1.2.3     Sealed   54s
$ kubectl get vaultserver -n demo
NAME    NODES   VERSION   STATUS    AGE
vault   1       1.2.3     Running   68s
```

Since the status is `Running` that means you have deployed vault successfully.
So, you are ready to go with Vault.

On deployment of `VaultServer` crd, the KubeVault operator performs the following tasks:

- Creates a `deployment` for Vault named after VaultServer crd
    ```console
    $ kubectl get deployment -n demo
    NAME    READY   UP-TO-DATE   AVAILABLE   AGE
    vault   1/1     1            1           25m
    ```
- Creates a `service` to communicate with vault pod/pods
    ```console
    $ kubectl get services -n demo
    NAME    TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)                         AGE
    vault   NodePort   10.110.35.39   <none>        8200:32580/TCP,8201:30062/TCP   20m
    ```
- Creates an `AppBinding` that hold information for performing authentication on Vault.
    ```console
    $ kubectl get appbindings -n demo
    NAME    AGE
    vault   30m
    ```
- Creates a `Service account` which will be used by the AppBinding for performing authentication.
    ```console
    kubectl get sa -n demo
    NAME                       SECRETS   AGE
    vault                      1         36m
    ```
- Unseals Vault and stores the Vault root token. For `kubernetesSecret` mood, operator creates a k8s secret containing root token.
    ```console
    $ kubectl get secrets -n demo
    NAME                                   TYPE                                  DATA   AGE
    vault-keys                             Opaque                                5      42m
    ```

- Enables `kubernetes auth method` creates k8s auth role with vault policies for the service account on Vault
