import { client } from './common/dynamodb';
import { CreateTableCommand, ResourceInUseException } from '@aws-sdk/client-dynamodb';
import app from './apps/local';

const port = process.env.PORT || 3001; // Default to port 3001 if not provided

const main = async () => {
  const { TABLE_NAME, AWS_REGION, DYNAMODB_ENDPOINT } = process.env;

  // Validate required environment variables
  if (!TABLE_NAME || !AWS_REGION) {
    console.error('Error: Missing required environment variables (TABLE_NAME, AWS_REGION).');
    process.exit(1);
  }

  console.log(`Using Table: ${TABLE_NAME}`);
  console.log(`Region: ${AWS_REGION}`);
  if (DYNAMODB_ENDPOINT) {
    console.log(`DynamoDB Endpoint: ${DYNAMODB_ENDPOINT} (local development)`);
  }

  try {
    // Initialize the DynamoDB table
    await client.send(
      new CreateTableCommand({
        TableName: TABLE_NAME,
        AttributeDefinitions: [
          { AttributeName: 'PK', AttributeType: 'S' },
          { AttributeName: 'SK', AttributeType: 'S' },
        ],
        KeySchema: [
          { AttributeName: 'PK', KeyType: 'HASH' },
          { AttributeName: 'SK', KeyType: 'RANGE' },
        ],
        BillingMode: 'PAY_PER_REQUEST', // Use on-demand billing for real AWS DynamoDB
      }),
    );
    console.log('Successfully created a DynamoDB table.');
  } catch (e) {
    if (e instanceof ResourceInUseException) {
      console.log('Table already exists.');
    } else {
      console.error(`Error creating DynamoDB table: ${e.message}`);
    }
  }

  // Start the application
  app.listen(port, () => {
    console.log(`Listening at http://localhost:${port}`);
  });
};

// Run the main function
main();
