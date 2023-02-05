/*# the Bucket and the DynamoDB table are created first. 
 After the creation, Backend can now be implemented.
 run "terraform init" and then "terraform apply" */

 terraform {
   backend "s3" {
     bucket         = "akymbo-s3-bucket"
     key            = "terraform.tfstate"
     region         = "us-east-1"
     dynamodb_table = "terraform-state-db"
   }
 }