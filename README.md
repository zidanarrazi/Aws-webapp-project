# Aws-webapp-project

## 🌐 Project: AWS-Powered Idea Submission App
This project demonstrates how to deploy a scalable, secure web application using AWS services such as EC2, RDS, S3, ALB, Auto Scaling, and CloudFront—all managed via Terraform.

---

## 🧱 Infrastructure Overview
- **VPC** with public/private subnets in 2 AZs
- **EC2 (Flask)** in Auto Scaling Group for backend API
- **ALB** to load balance traffic to EC2
- **RDS MySQL** in private subnet for storing ideas
- **S3 + CloudFront** to host frontend static site
- **IAM** for secure access between services

---

## 🚀 Deployment Steps

### 1. Configure variables
In `terraform/variables.tf` or using `terraform.tfvars`:
```hcl
aws_region    = "ap-southeast-1"
key_name      = "your-key-pair"
ami_id        = "ami-xxxxxxxx" # Amazon Linux 2 AMI
s3_bucket_name = "your-unique-frontend-bucket"
db_password   = "secure-db-password"
```

### 2. Initialize Terraform
```bash
cd terraform
terraform init
```

### 3. Plan & Apply
```bash
terraform apply -var-file="terraform.tfvars"
```

Wait for output showing the ALB DNS and RDS endpoint.

### 4. Deploy Frontend
```bash
aws s3 cp ../frontend/index.html s3://your-unique-frontend-bucket/
```
Open CloudFront URL to access the form.

### 5. Update Frontend
Edit `index.html`:
```js
fetch('http://YOUR_ALB_DNS/submit', { ... })
```

---

## 🔍 Test the App
- Visit frontend via CloudFront URL
- Submit an idea via the form
- Backend should store it in RDS

To view stored ideas, log into the RDS instance:
```sql
SELECT * FROM ideas;
```

---

## 💥 Failure Simulation
Terminate EC2 instance manually:
```bash
aws ec2 terminate-instances --instance-ids i-xxxxxxxxxxxxx
```
Auto Scaling will automatically launch a new instance.

---

## 🛡️ Security Best Practices
- All resources isolated in private/public subnets
- EC2 cannot be reached directly from the internet
- RDS access only allowed from EC2
- S3 uses public policy only for static website files

---

## 📌 TODO
- Add GitHub Actions CI/CD
- Store DB creds in AWS Secrets Manager
- Add HTTPS via ACM & CloudFront/ALB cert

---

## 🙌 Credits
Built as a hands-on Cloud Engineer learning project using AWS + Terraform.
