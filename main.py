import requests 
import boto3

response = requests.get('http://192.168.111.136:80')
print(response.status_code)