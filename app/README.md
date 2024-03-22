# Working with a stack locally
Make sure to have terragrunt and terraform installed.

    brew install terraform

    brew install terragrunt

Ensure AWS credentials are set to match your local environment.
The following command will do the trick.

    aws configure

Make sure to update the account.hcl file to match your environment.
Replace all values in square brackets with your own values.

    vim account.hcl

Then use the following commands to trigger terraform and use the local modules.

    terragrunt run-all plan --terragrunt-source-update --terragrunt-source ../../../
    terragrunt run-all apply --terragrunt-source-update --terragrunt-source ../../../
    terragrunt run-all destroy --terragrunt-source-update --terragrunt-source ../../../

Remove the --terragrunt-source param to fetch the remotes from git.
If you experience issues connecting to the remote references inside the terragrunt hcl files, then 
feel free to update them to match your clones for the repo.

    terragrunt run-all plan --terragrunt-source-update
    terragrunt run-all apply --terragrunt-source-update
    terragrunt run-all destroy --terragrunt-source-update