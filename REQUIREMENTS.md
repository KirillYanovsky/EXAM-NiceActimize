# Actimize Interview EKS Project

Please prepare Terraform code which will be able to deploy the following resources on any AWS account in a given region:

- **EKS Cluster**
  - Cluster should use the latest available Kubernetes version (supported by AWS in EKS service)  
    __Ready__
  - It should have one node group with a minimum of 1 and a maximum of 5 on-demand nodes of any EC2 type  
    __Ready__
  - It should have only private API server endpoint access.  
    __At the moment tf-code work only with public subnets (for easy access to EKS), for private endpoint need redo vpc configuration (private subnet etc) and use another method to access EKS (Bastion, VPN, ssh-tunell etc..).
    If it’s an important moment, I can finish it__
  - It should have one cluster and one additional security group.  
    __Ready__
  - CoreDNS and VPC-CNI should be deployed as EKS add-ons  
    __Ready__
  - The cluster should support nodes autoscaling, horizontal pod autoscaling, and EBS persistent volumes.  
    __Ready (for node autoscaling deployed helm chart cluster-autoscaler, for HPA - deployed helm chart metrics-
    server, for EBS persistent volumes - deployed add-on aws-ebs-csi-driver)__

There are no restrictions when it comes to code files and folder structure.

Solution can be elaborated with actual code or with pseudocode, which will follow the real use-case.

Questions can be asked by sending an email to (all of them in cc, English language):

- <merav.fester@niceactimize.com>
- <nasser.obaid@niceactimize.com>

Final solution should be sent to the same emails with a zip file in attachment.
