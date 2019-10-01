---
title: KubeVault Concepts
menu:
  docs_{{ .version }}:
    identifier: concepts-architecture
    name: Architecture
    parent: concepts
    weight: 20
menu_name: docs_{{ .version }}
section_menu_id: concepts
---

> New to KubeVault? Please start [here](/docs/concepts/README.md).


![vault operator architecture](/docs/images/concepts/architecture.svg)

# Architecture

Vault operator is composed of following controllers:

- A **Vault Server controller** that deploys Vault in Kubernetes cluster. It also injects unsealer and stastd export as sidecar to perform unsealing and monitoring.

- An **Auth controller** that enables auth method in Vault.

- A **Policy controller** that manages Vault policy and also bind the policy with Kubernetes ServiceAccount.

- A **Secret Engine controller** that enables and configures secret engines based on the given configuration.

- A set of **Role controllers** that configure secret engine roles which are used to generate credentials.

- A set of **AccessKeyRequest controllers** that generate and issue credentials to user under secret engine roles.
