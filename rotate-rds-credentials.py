import boto3
import os 
import json

secret_id = os.environ.get('SECRET_ID')  
rds_instance_id = 'db-FJI6FS5WODFINMYQAKS5PGNS6Q'  
new_username = 'foo'  
new_password = os.environ.get("NEW_PASSWORD")    

# Create a boto3 client for Secrets Manager and RDS
secretsmanager_client = boto3.client('secretsmanager')
rds_client = boto3.client('rds')

def update_secret(secret_id, new_username, new_password):
    try:
        # Update the secret in Secrets Manager with new credentials
        secret_string = json.dumps({
            'username': new_username,
            'password': new_password
        })
        response = secretsmanager_client.update_secret(
            SecretId=secret_id,
            SecretString=secret_string
        )
        print(f'Successfully updated secret {secret_id}.')
        print(response)
    except Exception as e:
        print(f'Error updating secret: {e}')

def update_rds_instance(password):
    try:
        # Modify the RDS instance with new password
        response = rds_client.modify_db_instance(
            DBInstanceIdentifier=rds_instance_id,
            MasterUserPassword=password,
            ApplyImmediately=True  # Apply changes immediately
        )
        print(f'Successfully updated RDS instance {rds_instance_id}.')
        print(response)
    except Exception as e:
        print(f'Error updating RDS instance: {e}')

# Update the secret and RDS instance with the new credentials
update_secret(secret_id, new_username, new_password)
update_rds_instance(new_password)