bucket       = "hivemind-tfstate-dev-906099689351-eu-north-1-an"
key          = "greeter/terraform.tfstate"
region       = "eu-north-1"
encrypt      = true
use_lockfile = true 
kms_key_id   = "alias/infra-dev-tfstate-s3"