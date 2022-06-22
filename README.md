# ghost-aws-deployment
Ghost blogging platform AWS deployment

## Create infrastructure - initial deployment

### Requirements

You will need:
* Terraform 1.x
* Packer - latest version
* Python 3 and Python 3 virtualenv

### Creating AMI
First, let's create a self-made AMI for reuse at a later point.

Set up Ansible to be run later on by Packer
```shell
cd packer
python3 -m venv venv
source venv/bin/activate
pip install -U pip
pip install -r ansible/requirements.txt
cd ansible
ansible-galaxy install -r requirements.yml
cd ..
```

Set up AWS access and run Packer
```shell
export AWS_DEFAULT_REGION=eu-north-1
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

packer build builder.json.pkr.hcl
```

### Deploying infrastructure and an EC2 instance with Ghost
After successful build, we can deploy our infrastructure and an EC2 with Ghost preinstalled.

```shell
cd terraform
export TF_VAR_aws_account_id=123AWSACCOUNTID
# or
# export TF_VAR_aws_accout_id=$(`aws sts get-caller-identity --query "Account" --output text`)
cd bootstrap
terraform init
terraform apply
```

Now you will need the following before we proceed:
* Your public ssh key and put it inside `variables.tf`

```shell
cd ..
cd main
terraform init
terraform apply
```

This should deploy all resources and output IP address of the EC2 instance.