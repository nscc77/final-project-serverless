#!/bin/bash

# Define the path to the .env file
cd ../frontend
env_file="./.env"

# Replace the existing values in the .env file
sed -i "s/backend_url/$VITE_BACKEND_API_URL/g" "$env_file"
sed -i "s/user_pool_id/$VITE_USER_POOL_ID/g" "$env_file"
sed -i "s/user_pool_client_id/$VITE_USER_POOL_CLIENT_ID/g" "$env_file"
sed -i "s/aws_region/$VITE_AWS_REGION/g" "$env_file"

npm run build