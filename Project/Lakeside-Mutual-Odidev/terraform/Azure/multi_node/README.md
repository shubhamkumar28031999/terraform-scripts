# Multi-node terraform configurations on Azure

This setup uses a jump server (also known as a bastion host) to communicate with Lakeside and Locust instances that are deployed under the private subnet. A jump server setup creates a security barrier between networks, preventing outsiders from maliciously gaining access to sensitive company data. 

Before using the terraform commands we need to modified some files first before deploying Azure VM. First we need to provide Azure location in ```./variable.tf``` file.

```
# Define Azure region for resource placement.
variable "location" {
  default     = "eastus2"
  description = "Azure region for deployment of resources."
}
```
To deploy the Lakeside on single instances, by default we are using the Standard_D2ps_v5 VM for Lakeside master and 3 lakeside worker node VM, while to deploy the Locust instance in the private subnet, we are using the Standard_D2ps_v5 VM. In order to connect to these instances, we are using the jump server which uses a Standard_D2ps_v5 VM by default. The above default values can be configured in ```./variable.tf``` files. 

```
# Bastion Host VM size
variable "bastion_host_VM_size" {
  default     = "Standard_D2ps_v5"
  description = "Bastion Host VM size"
}

# Lakeside master node VM size
variable "lakeside_master_VM_size" {
  default     = "Standard_D2ps_v5"
  description = "Lakeside master node VM sizee"
}

# Lakeside worker nodes VM size
variable "lakeside_node_VM_size" {
  default     = "Standard_D2ps_v5"
  description = "Lakeside worker node VM size"
}

# number of lakeside worker nodes 
variable "node_count" {
  default     = 3
  description = "Number of lakeside worker node"
}

# Locust VM size
variable "locust_VM_size" {
  default     = "Standard_D2ps_v5"
  description = "Locust VM size"
}
```

## Terraform commands

To deploy the instances, we need to initialize Terraform using the below-mentioned command inside the terraform directory. This command will download all the configuration files which are needed to deploy the instance on Azure.
```
# terraform init
```

Now we need to apply our Terraform scripts to create the instances with the configurations which we have mentioned in the Terraform files. To apply the Terraform script use the below-mentioned command: -  

```
# terraform apply
```

**Note: -** This Terraform script is configured in such a way it will auto-generate the inventory file for the Ansible and environmentVariable.py file for load testing. 
