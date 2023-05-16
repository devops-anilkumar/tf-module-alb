#CREATES SECURITY GROUP - PUBLIC
resource "aws_security_group" "alb_public" {
  count       = var.INTERNAL ? 0 : 1
  name        = "robot-${var.ENV}-public-alb-sg"
  description = "Allow public traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description      = "allow HTTP trafic from public"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "robot-${var.ENV}-public-alb-sg"
  }
}

#CREATES SECURITY GROUP - PRIVATE
resource "aws_security_group" "alb_private" {
  count       = var.INTERNAL ? 1 : 0
  name        = "robot-${var.ENV}-private-alb-sg"
  description = "Allow internal traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description      = "allow HTTP trafic from internal network"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [data.terraform_remote_state.vpc.outputs.VPC_ID]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "robot-${var.ENV}-private-alb-sg"
  }
}