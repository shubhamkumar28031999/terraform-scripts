resource "aws_security_group" "only_ssh_bositon" {
    depends_on=[aws_subnet.Lakeside_Jump_Subnet]
    name        = "only_ssh_bositon"
    vpc_id      =  aws_vpc.Lakeside_VPC.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["${var.jump-server-IP-Range}"]
      }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "only_ssh_bositon"
    }
}

resource "aws_security_group" "locust_test_lakeside" {
    name        = "locust_test_lakeside"
    vpc_id     = aws_vpc.Lakeside_VPC.id

    ingress {

        from_port   = 8089		
        to_port     = 8089
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
      
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
}

resource "aws_security_group" "lakeside_http" {
    name        = "allow_http"
    vpc_id     = aws_vpc.Lakeside_VPC.id

    ingress {

        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }   

    ingress {

        from_port   = 3010
        to_port     = 3010
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }  

    ingress {

        from_port   = 3020
        to_port     = 3020
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      } 

    ingress {

        from_port   = 9000
        to_port     = 9000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }   

    ingress {

        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

    ingress {
        from_port   = 8090
        to_port     = 8090
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_http"
      }
}

resource "aws_security_group" "only_ssh_private_instance" {
    name        = "only_ssh_private_instance"
    description = "allow ssh bositon inbound traffic"
    vpc_id      =  aws_vpc.Lakeside_VPC.id

    ingress {
        description = "Only ssh_sql_bositon in public subnet"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        security_groups=[aws_security_group.only_ssh_bositon.id]
    
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks =  ["::/0"]
      }

    tags = {
      Name = "only_ssh_sql_bositon"
    }
}
