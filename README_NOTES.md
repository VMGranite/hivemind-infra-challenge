# Hivemind Challenge

**Author:** Veronica Granite

## AWS Terminal Commands
`aws login`

## Terraform State File
The project utilizes a S3 Bucket for remote state file storage. 
There is a Bucket for each environment for isolation. ["dev", "test", "prod"]
The buckets utilize features: 
- Versioning 
- Access
- Encryption
- use_lockfile

Using proper bucket per environment: Add to deploy.yml

`terraform init -backend-config=backend-configs/dev.hcl`

`terraform init -backend-config=backend-configs/dev.hcl -reconfigure`

`terraform plan -var-file=environments/dev.tfvars`

## Developer Notes:
Mac OS
- brew install go
- cd /hivemind-infra-challenge
- HELLO_TAG=local-test go build -o greeter greeter.go
./greeter

## Docker and Kubernetes Notes
Docker
docker compose up --build
curl localhost:8080

## GitHub Actions Pipeline
- Only the pipeline can make changes
- Pull Requests required 
- Terraform Plan can be performed by humans, but not apply. 

Workflows:
- EC2 Image for Application/ Docker
- Terraform Infrastructure Deployment
- ArgoCD

