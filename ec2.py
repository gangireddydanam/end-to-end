
import boto3
import csv
AWS_REGION = "ap-southeast-2"

ec2_resource = boto3.resource('ec2', region_name=AWS_REGION)
fo=open('vo.csv','w',newline='')
data_obj=csv.writer(fo, delimiter=",")
data_obj.writerow([ 'volume_Id','volume_size',])
for volume in ec2_resource.volumes.all():
    data_obj.writerow([volume.id,volume.size,])
fo.close()