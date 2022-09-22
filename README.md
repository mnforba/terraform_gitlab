# Gitlab CI/CD Pipeline with Terraform

### This project utilizes Gitlab CI/CD pipeline and Terraform modules to deploy infrastructure in AWS. The terraform state will be stored in AWS S3. The infrastructure that will be built is a VPC with 2 public subnets and an Autoscaling group of EC2 instances.:

### Prerequisites
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) installed and configuration
- [Terraform](https://www.terraform.io/downloads) installed
- Github account
- Gitlab account and access token
- IDE, VSCode

### S3 Bucket
Create the S3 bucket which will be out Terraform backend and store the Terraform state. 
- On your terminal (I will use VSCode) use the command: `aws s3api create-bucket --bucket <bucket-name>` or `aws s3 mb s3://bucket-name --region us-east-1 --endpoint-url https://s3.us-east-1.amazonaws.com`
  
### Code
We edit the core that we will be using to deploy the infrastructure as code. You will need to fork my repository from Github * [Website project (fork this)](https://github.com/mnforba/terraform_gitlab.git)
- The file system contains all Terraform modules and what you need to built the project in Gitlab.
- Update the `backend.tf` file to include the S3 bucket name you created.
- The pipeline template in Gitlab provide the CI/CD workflow for the project. The stages of Terraform are validate code, plan, apply and finally destroy. The `before-script` is where Terraform will initialize the backend, which is the S3 bucket. The `state.config` file to configure the backend. 

## Gitlab
- Click on `Create new project > Run CI/CD for external repository`. Then click on connect repositories from Github. You will need to auth with Github
- On the left hand side navigation menu click on `Settings > CI/CD` then expand the `Variables` section. Add your `AWS_ACCESS_KEY_ID, AWS_DEFAULT_REGION, AWS_SECRET_ACCESS_KEY, and GITLAB_TOKEN`.
- Pipeline is ready to be created. Navigate to the left hand side of the screeen and select `CI/CD > Pipelines`, then click on `Run pipeline`. Since our variables are already set select `Run pipeline` again! The pipeline will show the stages we had assigned in the pipeline template. 
- For the apply and destroy stages, I had selected manual approval so those will need to be approved before the stage can be completed. To do so click on `apply` and then `Trigger this manual action`

### Verification on AWS
To verify that Terraform code did indeed successfully launch our infrastructure head over to the AWS console.
- EC2 instances navigate to `Auto Scaling groups` to view the auto scaling group created
- On Instances check to see that 2 new instances have been created. To check that the instances have internet access, grab the public ipv4 address and paste into a browser.
- Head over to S3, you should see a state file in your bucket

### Automation
Now if changes are made to the code in GitLab it should trigger the pipeline to make those changes automatically. To demonstrate this, change the code to have a desired capacity of 3 EC2 instances rather than 2. 
- Commit the changes to the main branch, which is not best practice, but practical for demonstration purposes. Go back over to the pipeline and you will see it was triggered by the change committed. 
- manually approve the apply again. Once it is completed, check back in the AWS console.

### Destroy
To clean up, I included a destroy stage in my plan. 
- In the GitLab pipeline select the `destroy` phase and click `Trigger this manual action`. This will destroy all of the infrastructure built in AWS. 
