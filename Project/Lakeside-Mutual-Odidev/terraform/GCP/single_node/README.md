# Single-node terraform configurations on GCP

## Before you begin

Any computer which has the required tools installed can be used for this section.

You will need a [Google Cloud account](https://console.cloud.google.com/). Create an account if needed.

Two tools are required on the computer you are using. Follow the links to install the required tools.
* [Terraform](https://developer.hashicorp.com/terraform/downloads)
* [Google Cloud CLI](https://cloud.google.com/sdk/docs/install-sdk)

## Deploy Arm instances on GCP and provide access via Jump Server

A Jump Server (also known as a bastion host) is an intermediary device responsible for funneling traffic through firewalls using a supervised secure channel. By creating a barrier between networks, jump servers create an added layer of security against outsiders wanting to maliciously access sensitive company data. Only those with the right credentials can log into a jump server and obtain authorization to proceed to a different security zone.

### Generate an SSH key-pair

Generate an SSH key-pair (public key, private key) using `ssh-keygen`. To generate the key-pair use the below mentioned command.

```
ubuntu@ubuntu:~$ ssh-keygen

Generating public/private rsa key pair.
Enter file in which to save the key (/home/ubuntu/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/ubuntu/.ssh/id_rsa
Your public key has been saved in /home/ubuntu/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:2shh6Un0J3Kfpj/iCopx0V23vpIgLdrlx3zg9fwIMvA ubuntu@ubuntu
The key's randomart image is:
+---[RSA 3072]----+
|                 |
|                 |
|      . . .      |
|   . o + . .     |
|  . ..O S o      |
|   .o=+@.=..     |
|. .o.=*=E+*o     |
| +..... O=ooo.   |
|. .   .+o=o....  |
+----[SHA256]-----+
```

### Deploying Arm instances on GCP and providing access via Jump Server


Before using the terraform commands we need to modified some files first before deploying GCP machines. Change the following code in **terraform.tfvars** This file contains actual values of the variables defined in **variables.tf**

```
project                   = "<project ID>"
region                    = "us-central1"
zone                      = "us-central1-a"
vm_username               = "<GCP_username>"
bastion_host_machine_type = "t2a-standard-1"
lakeside_machine_type     = "t2a-standard-2"
locust_machine_type       = "t2a-standard-2"
```

**NOTE:-** Replace **project_ID** with your value which can be found in the [Dashboard](https://console.cloud.google.com/home?_ga=2.56408877.721166205.1675053595-562732326.1671688536&_gac=1.125526520.1675155465.CjwKCAiAleOeBhBdEiwAfgmXfwdH3kCFBFeYzoKSuP1DzwJq7nY083_qzg7oyP2gwxMvaE0PaHVgFhoCmXoQAvD_BwE) of Google Cloud console. The [region and zone](https://cloud.google.com/compute/docs/regions-zones#available) are selected depending on the machine type. In our case, it's the [Tau T2A](https://cloud.google.com/compute/docs/general-purpose-machines#t2a_machines) series.

## Terraform commands

To deploy the instances, we need to initialize Terraform using the below-mentioned command inside theterraform directory. This command will download all the configuration files which are needed to deploy the instance on GCP.
```
# terraform init
```

Now we need to apply our Terraform scripts to create the instances with the configurations which we have mentioned in the Terraform files. To apply the Terraform script use the below-mentioned command: -  

```
# terraform apply
```

**Note: -** This Terraform script is configured in such a way it will auto-generate the inventory file for the Ansible and environmentVariable.py file for load testing. 
