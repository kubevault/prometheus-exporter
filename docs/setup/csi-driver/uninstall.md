---
title: Uninstall
description: Vault CSI Driver Uninstall
menu:
  product_vault:
    identifier: uninstall-csi-driver
    name: Uninstall
    parent: setup
    weight: 10
product_name: csi-driver
menu_name: product_vault
section_menu_id: setup
---

# Uninstall Vault CSI Driver

If you installed csi driver using YAML then run:

```console
kubectl delete -f  https://raw.githubusercontent.com/kubevault/csi-driver/master/hack/deploy/releases/csi-vault-v0.1.2.yaml
```

If you used HELM to install Vault CSI driver, then run following command

```console
helm del --purge <name>
```
