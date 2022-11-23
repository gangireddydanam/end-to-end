import boto3
import csv 
client = boto3.client('rds')
response = client.describe_db_instances(
)
print (response)

