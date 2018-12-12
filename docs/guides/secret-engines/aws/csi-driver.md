---
title: CSI Driver with AWS
description: Vault CSI Driver with AWS secret engine
menu:
  product_vault:
    identifier: aws-csi-driver
    name: AWS CSI Driver
    parent: aws
    weight: 10
product_name: csi-driver
menu_name: product_vault
section_menu_id: guides
---
# Setup AWS secret engine for Vault CSI Driver

## Configure AWS

Create IAM policy on AWS with following and copy the value of policy ARN:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:AttachUserPolicy",
        "iam:CreateAccessKey",
        "iam:CreateUser",
        "iam:DeleteAccessKey",
        "iam:DeleteUser",
        "iam:DeleteUserPolicy",
        "iam:DetachUserPolicy",
        "iam:ListAccessKeys",
        "iam:ListAttachedUserPolicies",
        "iam:ListGroupsForUser",
        "iam:ListUserPolicies",
        "iam:PutUserPolicy",
        "iam:RemoveUserFromGroup"
      ],
      "Resource": [
        "arn:aws:iam::ACCOUNT-ID-WITHOUT-HYPHENS:user/vault-*"
      ]
    }
  ]
}
```

## Configure Vault

To use secret from `aws` secret engine, you have to do following things.

1. **Enable `AWS` Engine:** To enable `AWS` secret engine run the following command.

   ```console
   $ vault secrets enable aws
   Success! Enabled the aws secrets engine at: aws/
   ```

2. **Crete AWS config:** To communicate with AWS for generating IAM credentials, Vault needs to configure credentials. Run:

    ```console
    $ vault write aws/config/root \
        access_key=AKIAJWVN5Z4FOFT7NLNA \
        secret_key=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 \
        region=us-east-1
    ```
