# Crypto Coins Stream AWS
## OBJECTIVES: 
1. The current data of ten crypto coins (like Bitcoin and Ethereum) will be requested in the [mercado-bitcoin API](https://www.mercadobitcoin.net/api/) using an AWS Lambda Function.
2. This Lambda function will send the collected data to an AWS Firehose Stream that will deliver the data to:
	
 	a. An index in an AWS Elasticsearch domain. This will allow the creation of a real-time dashboard for visualization.

 	b. An AWS S3 bucket for archiving.
- The AWS infrastructure will be automatically created using [Terraform](https://www.terraform.io). You can customize this project by changing the Terraform files in the "**infra/**" folder.

---
## Data Schema:
The below JSON is an example of the documents in the ElasticSearch index and the objects in the S3 bucket.
```json
{
	  "collected_tstamp": "2022-09-09 13:00:00.00000",    # Timestamp that the AWS Lambda function collected the crypto data
	  "coins": {                                          # Coins data
		    "Coin name": {
			    "high": "10.10",
			    "low": "9.99",
			    "vol": "12.11",
			    "last": "10.09",
			    "buy": "11.00",
			    "sell": "10.11",
			    "open": "10.00",
			    "date": 1662692714
		    },
		    "Coin name": {}
	}
}
```

## Important folders/files:
- **deploy/.env/**: File needed with your AWS credentials that will be used to create this project.
- **infra/modules/**: Folder with Terraform files for the infrastructure as code (IaC).
- **infra/resources/lambda/function/get_crypto_data.py**: The python script that gets crypto coins data and sends it to an AWS Firehose Delivery Stream.
---
# How to use this project:
You should edit the files that ends with "**_.auto.tfvars_**" in the "**_infra_**" folder, especially:
**infra/s3.auto.tfvars**: The "**s3_bucket_name**" variable.
**infra/firehose.auto.tfvars**: The "**s3_backup_mode**" variable, can be "**FailedDocumentsOnly**" or "**AllDocuments**". The default is "**AllDocuments**". More info [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream#elasticsearch_configuration).

### If you have Terraform and AWS CLI (configured with your credentials) installed in your local machine and don't want to use Docker:
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
##### Requirements: Have [Docker](https://www.docker.com) and [Docker Compose](https://docs.docker.com/compose/install/#install-compose) installed on your machine.

---
1. Create a file named "**.env**" inside the "**deploy/**" folder and write your **AWS credentials** for Terraform to use to create the infrastructure, this file should follow the structure of the "**deploy/.env.example**" file.
2. Execute the bellow command to init the Docker container and Terraform:
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
1. Open the "**Kibana Endpoint**" URL in the browser, and login with your ElasticSearch master username and password configured in the **infra/elastic_search.auto.tfvars** file.
2. Click on the "**Security**" section on the sidebar.
3. Click on the "**Roles**" section.
4. Click on the "**all_access**" role.
5. Click on the "**Mapped users**" and then click on the "**Manage mapping**" button.
6. Add the ARN of the AWS Firehose IAM role on the "**Backend roles**".
7. Click on the "**map**" button.
8. Now the AWS Firehose can send data to Elasticsearch.

## Testing:
1. To test this project, go to the Lambda function on the AWS Console and test the function a couple of times or add a Trigger to the function.
2. Go to AWS S3 to check if the objects have been created.
3. Go to the "**Query Workbench**" section on Kibana to execute SQL or PPL queries on the Elasticsearch data, like:
```sql
SHOW tables LIKE %; 			-- Show all indices in Elasticsearch
```
```sql
SELECT * FROM crypto-coins-*; 		-- Show all data from indices that match pattern crypto-coins-*
```
```sql
SELECT coins.BTC FROM crypto-coins-*;   -- Show all data about BTC (Bitcoin)
```
