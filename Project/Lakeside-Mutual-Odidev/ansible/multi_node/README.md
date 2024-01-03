# Multi-Node ansible configuration

This directory contains ```ec2-lakeside-master-config.yaml```, ```docker-swarm-config.yaml```, ```deploy_lakeside.yaml``` and ```ec2-locust-config.yaml``` files. All the files are used to install the dependencies and configure the Lakeside and Locust instances respectively. Additionally, ```ec2-lakeside-config.yaml``` Ansible script will also run the Lakeside Mutual. 

Before executing the the ansible scripts we need to give docker hub credentials and lakeside worker node IP in ```ec2-lakeside-master-config.yaml``` file. Lakeside worker node IP is gererated after execting the ```terraform apply``` command. 

```
- hosts: lakesideMaster
  become: True
  vars:
    - docker_username: <username>
    - docker_password: <password>
    - node_ip:  "<Any worker node IP>"
```


Use the below-mentioned commands in the following order to configure the instances.

```
# ansible-playbook -i hosts ec2-lakeside-master-config.yaml
# ansible-playbook -i hosts docker-swarm-config.yaml
# ansible-playbook -i hosts deploy_lakeside.yaml
# ansible-playbook -i hosts ec2-locust-config.yaml
```
