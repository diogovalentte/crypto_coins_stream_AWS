# Crypto Coins Stream AWS
## OBJECTIVES: 
1. Create indexes on AWS Elasticsearch with data of cryto coins like Bitcoin, Ethereum, etc.
2. All data will be archived in a AWS S3 bucket too.
3. The data of ten crypto coins will be requested in the [mercado-bitcoin API](https://www.mercadobitcoin.net/api/) using an AWS Lambda Function.
4. The Lambda function will send the data to an AWS Firehose Stream that will delivery the data to Elasticsearch (real time dashboards) and AWS S3 (archiving).
- The AWS infrastructure will be created using [Terraform](https://www.terraform.io) and you can customize this project changing the Terraform files on the "**infra/**" folder.

---
## Crypto Data Schema:
The bellow JSON is an example of the Documents in the ElasticSearch and the objects in the S3 bucket.
```json
{
	  "collected_tstamp": "2022-09-09 13:00:00.00000",    # Timestamp that the AWS Lambda function collected the crypto data
	  "coins": {                                          # Coins data
		    "Coin 1": {
			    "high": "10.10",
			    "low": "9.99",
			    "vol": "12.11",
			    "last": "10.09",
			    "buy": "11.00",
			    "sell": "10.11",
			    "open": "10.00",
			    "date": 1662692714
		    },
		    "Coin 2": {}
	}
}
```

## Important folders/files:
- **deploy/.env/**: File needed with your AWS credentials to run this project in a **Docker container**.
- **infra/modules/**: Folder with Terraform files for AWS Lambda, S3, Elasticsearch and Firehose.
- **infra/resources/lambda/function/get_crypto_data.py**: The python script that get crypto coins data and send to AWS Firehose Stream.
---
# How to use this project:
- You should edit the files with end "**_.auto.tfvars_**" in the "**_infra_**" folder, specially:
**infra/s3.auto.tfvars**: The "**s3_bucket_name**" variable.
**infra/firehose.auto.tfvars**: The "**s3_backup_mode**" variable, can be "**FailedDocumentsOnly**" or "**AllDocuments**". Default is "**AllDocuments**". More info [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream#elasticsearch_configuration).

### If you have Terraform installed in your local machine and don't want to use Docker:
1. Execute the bellow commands to init Terraform:
```sh
cd infra && terraform init
```
2. Execute the bellow command to create the infrastructure in AWS:
```sh
terraform apply
```
3. After the creation of the infrastructure is finished, you will see the output of the ARN of the AWS Firehose IAM role and the Kibana endpoint. Click [here](#configuring-the-aws-firehose-backend-role-on-elasticsearch) to configure the AWS Firehose backend role on ElasticSearch.
4. Execute the bellow command to destroy the AWS infrastructure:
```sh
terraform destroy
```
---

### If you want to use Docker:
##### Requiriments: Have [Docker](https://www.docker.com) and [Docker Compose](https://docs.docker.com/compose/install/#install-compose)

---
1. Create a file named "**.env**" inside the "**deploy/**" folder and write your **AWS credentials** for Terraform use to create the infrastructure, this file should follow the structure of the "**deply/.env.example**" file.
2. Execute the bellow command to init Terraform:
```sh
docker-compose -f deploy/docker-compose.yaml run --rm terraform init
```
3. Execute the bellow command to create the infrastructure in AWS:
```sh
docker-compose -f deploy/docker-compose.yaml run --rm terraform apply
```
4. After the creation of the infrastructure is finished, you will see the output of the ARN of the AWS Firehose IAM role and the Kibana endpoint. Click [here](#configuring-the-aws-firehose-backend-role-on-elasticsearch) to configure the AWS Firehose backend role on ElasticSearch.
5. Execute the bellow command to destroy the AWS infrastructure:
```sh
docker-compose -f deploy/docker-compose.yaml run --rm terraform destroy
```
---

### Configuring the AWS Firehose backend role on ElasticSearch:
1. Open the "**Kibana Endpoint**" URL in the browser, login with your ElasticSearch master username and password.
2. Click on the "**Security**" section on the sidebar.
3. Click on the "**Roles**" section.
4. Click on the "**all_access**" role.
5. Click on the "**Mapped users**" and then click on the "**Manage mapping**" button.
6. Add the ARN of the AWS Firehose IAM role on the "**Backend roles**".
7. Click on the "**map**" button.
8. Now the AWS Firehose can send data to Elasticsearch.

## Testing:
1. To test this project, go to the Lambda function on the AWS Console and test the function a couple times or add a Trigger to the function.
2. Then go to AWS S3 check the bucket objects created or go to the "**Query Workbench**" section on Kibana to execute SQL or PPL queries on the Elasticsearch data, like:
```sql
SHOW tables LIKE %; 			-- Show all indices in Elasticsearch
```
```sql
SELECT * FROM crypto-coins-*; 		-- Show all data from indices that match pattern crypto-coins-*
```
```sql
SELECT coins.BTC FROM crypto-coins-*;   -- Show all data about BTC (Bitcoin)
```
