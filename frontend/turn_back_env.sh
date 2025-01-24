#!/bin/bash

# Define the path to the .env file
cd ../frontend
env_file="./.env"

# Replace the existing values in the .env file

sed -i "s/$VITE_BACKEND_API_URL/backend_url/g" "$env_file"
sed -i "s/$VITE_USER_POOL_ID/user_pool_id/g" "$env_file"
sed -i "s/$VITE_USER_POOL_CLIENT_ID/user_pool_client_id/g" "$env_file"
sed -i "s/$VITE_AWS_REGION/aws_region/g" "$env_file"