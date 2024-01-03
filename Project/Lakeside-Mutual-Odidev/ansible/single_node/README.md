# Single node ansible configuration

This directory contains ```ec2-lakeside-config.yaml``` and ```ec2-locust-config.yaml``` files. Both files are used to install the dependencies and configure the Lakeside and Locust instances respectively. Additionally, ec2-lakeside-config.yaml Ansible script will also run the Lakeside Mutual. To configure the instances use the below-mentioned commands to run the Ansible script.

```
# ansible-playbook -i hosts ec2-lakeside-config.yaml
# ansible-playbook -i hosts ec2-locust-config.yaml
```
