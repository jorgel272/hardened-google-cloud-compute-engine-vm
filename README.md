# Deploy Compute Engine with Secure setting with Terraform
Deploy Compute Engine instances with security in mind with Terraform. 

The direct attached static IPv4 address is for testing purpose. It's recommend to not expose Compute Engine instances direcly to the internet, but placed behind a load balancer.

**What the Terraform does?**
1. Create VPC Network
2. Add subnet to VPC
3. Create Service Account
4. Add ServiceAccount Role to created Service Account
5. Assign minimum required Scope to Service Account
6. Reserve static internal and public IPv4 address
7. Deploy Linux based Compute Engine Instance

Happy coding, VAMOS!
