---
title: KubeVault Concepts
menu:
  docs_{{ .version }}:
    identifier: concepts-readme
    name: Overview
    parent: concepts
    weight: 10
menu_name: docs_{{ .version }}
section_menu_id: concepts
url: /docs/{{ .version }}/concepts/
aliases:
  - /docs/{{ .version }}/concepts/README/
---

# Concepts

Concepts help you learn about the different parts of the KubeVault and the abstractions it uses.

- What is KubeVault?
  - [Overview](/docs/concepts/what-is-kubevault.md). Provides a conceptual introduction to KubeVault operator, including the problems it solves and its use cases.
  - [Operator architecture](/docs/concepts/architecture.md). Provides a high level illustration of vault operator architecture.  



<ul class="nav nav-tabs" id="conceptsTab" role="tablist">
  <li class="nav-item">
    <a class="nav-link active" id="vault-server-tab" data-toggle="tab" href="#vault-server" role="tab" aria-controls="vault-server" aria-selected="true">Vault Server</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" id="secret-engine-tab" data-toggle="tab" href="#secret-engine" role="tab" aria-controls="secret-engine" aria-selected="false">Secret Engines</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" id="vault-policy-tab" data-toggle="tab" href="#vault-policy" role="tab" aria-controls="vault-policy" aria-selected="false">Vault Policies</a>
  </li>
</ul>

<div class="tab-content" id="conceptsTabContent">
  <div class="tab-pane fade show active" id="vault-server" role="tabpanel" aria-labelledby="vault-server-tab">

### [AppBinding](/docs/concepts/vault-server-crds/auth-methods/appbinding.md) 

Introduces a way to specify connection information, credential and parameters that are necessary for communicating with app/service.

### [Vault Server Version](/docs/concepts/vault-server-crds/vaultserverversion.md)
 
Introduces the concept of `VaultServerVersion` to specify the docker images of HashiCorp Vault, Unsealer and Exporter.

### [Vault Server](/docs/concepts/vault-server-crds/vaultserver.md)

Introduces the concept of `VaultServer` for configuring a HashiCorp Vault server in a Kubernetes native way.

- Vault Unsealer Options
  - [AWS KMS and SSM](/docs/concepts/vault-server-crds/unsealer/aws_kms_ssm.md)
  - [Azure Key Vault](/docs/concepts/vault-server-crds/unsealer/azure_key_vault.md)
  - [Google KMS GCS](/docs/concepts/vault-server-crds/unsealer/google_kms_gcs.md)
  - [Kubernetes Secret](/docs/concepts/vault-server-crds/unsealer/kubernetes_secret.md)
- Vault Server Storage
  - [Azure](/docs/concepts/vault-server-crds/storage/azure.md)
  - [DynamoDB](/docs/concepts/vault-server-crds/storage/dynamodb.md)
  - [Etcd](/docs/concepts/vault-server-crds/storage/etcd.md)
  - [GCS](/docs/concepts/vault-server-crds/storage/gcs.md)
  - [In Memory](/docs/concepts/vault-server-crds/storage/inmem.md)
  - [MySQL](/docs/concepts/vault-server-crds/storage/mysql.md)
  - [PosgreSQL](/docs/concepts/vault-server-crds/storage/postgresql.md)
  - [AWS S3](/docs/concepts/vault-server-crds/storage/s3.md)
  - [Swift](/docs/concepts/vault-server-crds/storage/swift.md)
  - [Consul](/docs/concepts/vault-server-crds/storage/consul.md)
- Authentication Methods for Vault Server
  - [AWS IAM Auth Method](/docs/concepts/vault-server-crds/auth-methods/aws-iam.md)
  - [Kubernetes Auth Method](/docs/concepts/vault-server-crds/auth-methods/kubernetes.md)
  - [TLS Certificates Auth Method](/docs/concepts/vault-server-crds/auth-methods/tls.md)
  - [Token Auth Method](/docs/concepts/vault-server-crds/auth-methods/token.md)
  - [Userpass Auth Method](/docs/concepts/vault-server-crds/auth-methods/userpass.md)
  - [GCP IAM Auth Method](/docs/concepts/vault-server-crds/auth-methods/gcp-iam.md)
  - [Azure Auth Method](/docs/concepts/vault-server-crds/auth-methods/azure.md)



</div>
<div class="tab-pane fade" id="secret-engine" role="tabpanel" aria-labelledby="secret-engine-tab">

### Secret Engine

`SecretEngine` is a Kubernetes `Custom Resource Definition`(CRD). It provides a way to enable and configure vault secret engine.


- AWS IAM Secret Engines
  - [AWSRole](/docs/concepts/secret-engine-crds/awsrole.md)
  - [AWSAccessKeyRequest](/docs/concepts/secret-engine-crds/awsaccesskeyrequest.md)

- GCP Secret Engines
  - [GCPRole](/docs/concepts/secret-engine-crds/gcprole.md)
  - [GCPAccessKeyRequest](/docs/concepts/secret-engine-crds/gcpaccesskeyrequest.md)

- Azure Secret Engines
  - [AzureRole](/docs/concepts/secret-engine-crds/azurerole.md)
  - [AzureAccessKeyRequest](/docs/concepts/secret-engine-crds/azureaccesskeyrequest.md)
  
- Database Secret Engines
  - [MongoDBRole](/docs/concepts/database-crds/mongodb.md)
  - [MySQLRole](/docs/concepts/database-crds/mysql.md)
  - [PostgresRole](/docs/concepts/database-crds/postgresrole.md)
  - [DatabaseAccessRequest](/docs/concepts/database-crds/databaseaccessrequest.md)

</div>
<div class="tab-pane fade" id="vault-policy" role="tabpanel" aria-labelledby="vault-policy-tab">

- Vault Policy Management
  - [VaultPolicy](/docs/concepts/policy-crds/vaultpolicy.md)
  - [VaultPolicyBinding](/docs/concepts/policy-crds/vaultpolicybinding.md)

</div>
</div>
