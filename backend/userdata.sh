# backend/user_data.sh
#!/bin/bash
yum update -y
yum install -y python3 git mysql
yum install -y python3-pip

cd /home/ec2-user
git clone https://github.com/your-org/webapp-project.git
cd webapp-project/backend
pip3 install flask mysql-connector-python

export DB_HOST="${rds_endpoint}"
export DB_USER="admin"
export DB_PASSWORD="your-password"
export DB_NAME="webapp"

nohup python3 app.py &