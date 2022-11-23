import boto3
session = boto3.session.Session()
s3_client = session.client('s3')
s3 = session.resource('s3')
for bucket in s3.buckets.all():
    result = s3_client.get_bucket_location(Bucket=bucket.name)
    # print(result)
    print(bucket.name,"|",result['LocationConstraint'])