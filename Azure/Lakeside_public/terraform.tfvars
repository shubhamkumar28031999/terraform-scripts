resource_group_location    = "eastus2"
resource_group_name_prefix = "rg-subham_kumar"

username="azureuser"
password = "password"


// lakeside master instance type 
lakeside_master_instance_type="Standard_D2ps_v5"
lakeside_master_computer_name ="master"

// lakeside node instance type 
lakeside_node_instance_type = "Standard_D2ps_v5"
lakeside_worker_node_computer_name = "node"
// Lakeside nodes
lakeside_nodes = 1



// Locust node instance type
locust_node_instance_type = "Standard_D96s_v5"
locust_computer_name = "locust"