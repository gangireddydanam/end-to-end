import boto3
ec2_obj=boto3.resource('ec2')
sg=boto3.resource('ec2')
for sg in sg.security_groups.all():
    print('security gropus:')
    print(sg.id)