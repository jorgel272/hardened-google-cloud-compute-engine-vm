# Deploy Google Cloud Compute Engine with hardened Security 
Deploy a hardened Compute Engine instance on Google Cloud with security in mind and using Terraform for deployment. The Terraform script has been set up to be deployed on its own, meaning an empty Google Cloud project.

The direct-attached static IPv4 address is for testing purposes. It's recommended not to expose Compute Engine instances directly to the internet but to place them behind a load balancer.

**What the Terraform plan does?**
1. Create VPC Network
2. Add subnet to VPC
3. Create Service Account
4. Add ServiceAccount Role to created Service Account
5. Assign minimum required Scope to Service Account
6. Reserve static internal and public IPv4 address
7. Deploy Linux based Compute Engine Instance
8. Create VPC firewall rules 

**Running the Terraform plan**
Make sure to adjust the Google Cloud project in the variables.tf file before deploying and change the "awesomename" placeholder to something Awesome ;) 

Run the Terraform plan:
- terraform init
- terraform apply

Happy coding, VAMOS!
