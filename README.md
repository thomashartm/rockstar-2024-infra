# AEM Rockstars 2024 - ChatAEM Infrastructure

This project is the IaC (Infrastructure as Code) stack for the ChatAEM Application

The project container all related stacks and covers topics such as
* authorization
* persistence
* API Integration
* processing

# Main solutions and their dependencies

In the following diagram you can see the main solutions and their interdependencies. The end solutions, those that would make sense to apply changes from withing their folder, appear with a tag form. The hard dependencies can be checked with a continuous line. The dotted line represents a soft dependency, meaning that the previous module has to be deployed once before, but after that the dependency is not there anymore since the output is read from a parameter store.

# Required Components and Status

| Task No. | Component                          | Status  | Description                                                                                                                         |
|----------|------------------------------------|---------|-------------------------------------------------------------------------------------------------------------------------------------|
|          | VPC                                | done    | The VPC is the main network infrastructure for the application. It contains the private and public subnets and the security groups. |
|          | Nat GW                             | done | ECR access                                                                                                                          |
|          | ALB                                | done | Access to chat container                                                                                                            |
|          | Route 53 domain                    | done | Subdomain delegation setting from an NC domain                                                                                      |
|          | ECR for Chat                       | done | Next JS chat container and API                                                                                                      |                                                                                                 |                                                                                                      |
|          | RDS to store embeddings            | done |                                                                                                                                     |
|          | Secret API Key                     | done |                                                                                                                                     |
|          | S3 for documentation data          | done | source for embeddings (not used right now)                                                                                          |                                                                                                              |
|          | ECS Cluster with Tasks for the app | done | runs the code                                                                                                                       |                                                                                                              |

# Rollout and Development
This stack uses terragrunt to manage the actual environment and terraform to configure the infrastructure resources.

## Working with Terragrunt

1. Go to you environment folder and select the stack.
2. Then run a terragrunt command as follows:

```
# Plans a stack but does not roll it out.
terragrunt run-all plan --terragrunt-source-update --terragrunt-source ../../../

# Applys a stack and rolls it out. These changes are persistent.
terragrunt run-all apply --terragrunt-source-update --terragrunt-source ../../../

# Destroys a stack. These changes are persistent.
terragrunt run-all destroy --terragrunt-source-update --terragrunt-source ../../../
```

## Working with Terragrunt smaller deployeable units

1. Go to you environment folder and select the stack.
2. Then run a terragrunt command as follows:

```
# Plans a stack but does not roll it out.
terragrunt run-all plan --terragrunt-source-update 

# Applys a stack and rolls it out. These changes are persistent.
terragrunt run-all apply --terragrunt-source-update

# Destroys a stack. These changes are persistent.
terragrunt run-all destroy --terragrunt-source-update
```

# Important notes

When using the CF function for authorization, make sure to update the function matching your environment.
Unfortunately Terraform does not allow us to do that right now without a lot of workarounds via scripts.

1. Associate the key value store with your function. And copy the id.
2. Open the CF function and update following two vars:

    const kvsId = '<your-key-value-store-id>';
    const aemAuthorUrl = '<https://your-aem-author-host>';
    
3. Add the following variables to your key value store

    apiKey="API key between CF and ALB which you should set in the settings store"
    hmac="Your hmac key which must match the AEM author hmac config"

4. Update the association.
 
Make sure the hmac matches the one configured with AEM as it is required to check the JWT signature.

Set the API key based on your needs. This key is used to authenticate the requests between the ALB and the CF function and must be set manually. 

