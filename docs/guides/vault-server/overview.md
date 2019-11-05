---
title: Vault Server Overview
menu:
  docs_{{ .version }}:
    identifier: overview-vault-server
    name: Overview
    parent: vault-server-guides
    weight: 10
menu_name: docs_{{ .version }}
section_menu_id: guides
---

> New to KubeVault? Please start [here](/docs/concepts/README.md).

# Overview

The KubeVault operator makes it easy to deploy, maintain and manage Vault servers in the Kubernetes cluster. It covers automatic initialization and unsealing and also stores unseal keys and root token in a secure way. It also has the following features:

- **Vault Policy Management**: Provides a Kubernetes native way to manage Vault policies and bind those policies to the users or the auth method roles.

  - [Vault Policy]()
  - [Vault Policy Binding]()

- **Vault Secret Engine Management**: Provides a Kubernetes native way to manage Vault secret engines.

  - [GCP Secret Engine]()
  - [AWS Secret Engine]()
  - [Azure Secret Engine]()
  - [Database Secret Engine]()

## Setup Vault Server

![Overview](/docs/images/guides/vault-server/overview_vault_server_guide.svg)

Deploy Vault server using the KubeVault operator:

- [Deploy Vault Server](/docs/guides/vault-server/vault-server.md)

 Configure external Vault server so that the  KubeVault operator can communicate with it:

- [Configure External Vault Server](/docs/guides/vault-server/external-vault-sever.md)
