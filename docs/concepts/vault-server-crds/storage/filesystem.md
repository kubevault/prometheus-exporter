---
title: Filesystem | Vault Server Storage
menu:
  docs_{{ .version }}:
    identifier: filesystem-storage
    name: Filesystem
    parent: storage-vault-server-crds
    weight: 20
menu_name: docs_{{ .version }}
section_menu_id: concepts
---

> New to KubeVault? Please start [here](/docs/concepts/README.md).

# Filesystem

The [Filesystem storage backend](https://www.vaultproject.io/docs/configuration/storage/filesystem.html) stores Vault's data on the filesystem using a standard directory structure. As the Filesystem backend does not support high availability (HA), it can be used for **single server** situations(i.e. vaultserver.spec.replicas: 1). A `VolumeClaimTemplate` is given to create (or patch if already exist)  a [PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims) so that Vault's data can be stored in the [PersistentVolume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/).

```yaml
apiVersion: kubevault.com/v1alpha1
kind: VaultServer
metadata:
  name: vault
  namespace: demo
spec:
  replicas: 1
  version: "1.2.3"
  serviceTemplate:
    spec:
      type: NodePort
  backend:
    file:
      path: /mnt/vault/data
      volumeClaimTemplate:
        metadata:
          name: vault-pvc
        spec:
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 50Mi
  unsealer:
    secretShares: 4
    secretThreshold: 2
    mode:
      kubernetesSecret:
        secretName: vault-keys
```

## spec.backend.file

To use Filesystem as storage backend in Vault server, specify the `spec.backend.file` in [VaultServer](/docs/concepts/vault-server-crds/vaultserver.md) CRD.

```yaml
spec:
  backend:
    file:
      path: /mnt/vault/data
      volumeClaimTemplate:
        metadata:
          name: vault-pvc
        spec:
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 50Mi
```

Here, we are going to describe various attributes of the `spec.backend.file` field.

### file.path

`file.path` is a `required` field that specifies the absolute path to the directory where the data will be stored.

```yaml
backend:
  file:
    path: /mnt/vault/data
```

### file.volumeClaimTemplate

`file.volumeClaimTemplate` is a `required` field that specifies a [PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims) object that  will provide stable storage using PersistentVolumes provisioned by a PersistentVolume Provisioner. The KubeVault operator will patch the PVC if it already exists otherwise, it will create a new PVC. On the deletion of VaultServer CRD, the PVC will not be affected.

```yaml
file:
  volumeClaimTemplate:
    metadata:
      name: vault-pvc
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 50Mi
```

#### file.volumeClaimTemplate.metadata

`volumeClaimTemplate.metadata` is an `optional` field that specifies a standard object's metadata. The following fields can be provided:

- `name` : `optional`. Specifies a name that uniquely identifies this object within the current namespace. Default to VaultServer's name.
- `namespace` : `optional`. Specifies a namespace name which is a DNS compatible label that objects are subdivided into. Default to VaultServer's namespace.
- `labels` : `optional`. Specifies a map of string keys and values that can be used to organize and categorize objects. Default to VaultServer's labels.

```yaml
volumeClaimTemplate:
  metadata:
    name: vault-pvc
    namespace: demo
    labels:
      app: vault
```

#### file.volumeClaimTemplate.spec

`volumeClaimTemplate.spec` is a `required` field that defines the desired characteristics of a volume. It contains all fields and features of a standard [PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims) object's spec.

Sub-fields are given below:

- `accessModes`
- `selector`
- `resources`
- `volumeName`
- `storageClassName`
- `volumeMode`
- `dataSource`

```yaml
file:
  volumeClaimTemplate:
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 50Mi
```
