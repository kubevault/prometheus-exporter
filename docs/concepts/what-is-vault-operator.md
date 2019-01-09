# What is Vault operator

Vault operator is Kubernetes controller for [Vault](https://www.vaultproject.io/). Vault is a tool for secrets management, encryption as a service, and privileged access management. It is developed by HashiCorp. Deploying, maintaining, and managing Vault in Kubernetes could be troublesome. Vault operators job is to ease those tasks so that developers can focus on using Vault.

# Why use Vault operator

Vault operator makes it easy to deploy, maintain and manage Vault in Kubernetes. It covers automatic initializing and unsealing and also stores unseal keys and root token in a secure way using cloud KMS (Key Management Service) service. It provides feature:

- Automatic initializing and unsealing Vault
- Manage Vault [Policy](https://www.vaultproject.io/docs/concepts/policies.html)
- Manage Vault [AWS secret engine](https://www.vaultproject.io/docs/secrets/aws/index.html#aws-secrets-engine)
- Manage Vault [MongoDB Database secret engine](https://www.vaultproject.io/api/secret/databases/mongodb.html)
- Manage Vault [MySQL Database secret engine](https://www.vaultproject.io/api/secret/databases/mysql-maria.html)
- Manage Vault [PostgreSQL Database secret engine](https://www.vaultproject.io/api/secret/databases/postgresql.html)
- Monitor Vault

# Core features

## Automatic Initializing and Unsealing Vault

When a Vault is started, it starts in a sealed state. In a sealed state, almost no operations are possible with Vault. So, you will need to unseal Vault. Vault operator provides automatic initializing and unsealing facility. When you deploy or scale up Vault, you don't have worry about unsealing new Vault Pod, Vault operator will do the task for you. Also, it provides a secure way to store unseal keys and root token.

## Manage Vault Policy

Policies in Vault provide a declarative way to grant or forbid access to certain paths and operations in Vault. You can create, delete and update policy in Vault using Vault operator. Vault operator also provides a way to bind Vault policy with Kubernetes ServiceAccount. ServiceAccount will have the permissions which are specified in the policy.

## Manage Vault AWS Secret Engine

AWS secret engine in Vault generates AWS access credentials dynamically based on IAM policies. This makes AWS IAM user management easier. Using Vault operator, you can configure AWS secret engine and issue AWS access credential from Vault. A User can request AWS credential and after it's been approved Vault operator will create Kubernetes Secret containing the AWS credential and also create RBAC Role and RoleBinding so that user can access the Secret.

# Manage Vault MongoDB Database Secret Engine

MongoDB database secret engine in Vault generates MongoDB database credentials dynamically based on configured roles. Using Vault operator, you can configure secret engine, create role and issue credential from Vault. A User can request credential and after it's been approved Vault operator will create Kubernetes Secret containing the credential and also create RBAC Role and RoleBinding so that user can access the Secret.

# Manage Vault MySQL Database Secret Engine

MySQL database secret engine in Vault generates MySQL database credentials dynamically based on configured roles. Using Vault operator, you can configure secret engine, create role and issue credential from Vault. A User can request credential and after it's been approved Vault operator will create Kubernetes Secret containing the credential and also create RBAC Role and RoleBinding so that user can access the Secret.

# Manage Vault Postgres Database Secret Engine

Postgres database secret engine in Vault generates Postgres database credentials dynamically based on configured roles. Using Vault operator, you can configure secret engine, create role and issue credential from Vault. A User can request credential and after it's been approved Vault operator will create Kubernetes Secret containing the credential and also create RBAC Role and RoleBinding so that user can access the Secret.

# Monitor Vault

Vault operator has native support for monitoring via [Prometheus](https://prometheus.io/). You can use builtin [Prometheus](https://github.com/prometheus/prometheus) scrapper or [CoreOS Prometheus Operator](https://github.com/coreos/prometheus-operator) to monitor Vault operator.

# Architecture

Vault operator is composed of following controllers:

- A **Vault Server controller** that deploys Vault in Kubernetes cluster. It also injects unsealer and stastd export as sidecar to perform unsealing and monitoring.

- A **Auth controller** that enables auth method in Vault.

- A **Policy controller** that manages Vault policy and also bind the policy with Kubernetes ServiceAccount.

- A **AWS secret engine controller** that configures secret engine, manages role and credential.

- A **Database secret engine controller** that configures database secret engine, manages role and credential.

![vault operator architecture](/docs/images/concepts/vault_operator_architecture.svg)