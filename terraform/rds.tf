# rds.tf
resource "aws_db_instance" "webapp_db" {
  identifier         = "webapp-db"
  engine             = "mysql"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  name               = var.db_name
  username           = var.db_user
  password           = var.db_password
  db_subnet_group_name = aws_db_subnet_group.webapp_db_subnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az           = true
  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "webapp_db_subnet" {
  name       = "webapp-db-subnet"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}