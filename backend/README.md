## Run locally
You can start a local backend by the following command:

```sh
# start DynamoDB local
docker-compose up -d

# start express
npm run local
```

We use [DynamoDB Local](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html) to mock DynamoDB locally. To use a DynamoDB table deployed on AWS, you can modify the environment variables defined in [`app.local.ts`](app.local.ts); set the `TABLE_NAME` and `AWS_REGION` environment variables to the actual table name and region, and remove the `DYNAMODB_ENDPOINT`. 

## Steps to add an endpoint
When you add an endpoint, please follow the below steps:

1. Add service directory (when necessary)
2. implement method in `controller.ts` for the service
3. Add request / response type definition to `types.ts`
4. Add route to `router.ts`
5. If you added a new service, add the route to app according to it is public API or not. (`apps` directory)

Note that there are endpoints that requires authentication and not (a.k.a. public endpoints).
These endpoints are separated by Express apps; Add your service to [apps/authenticated.ts](apps/authenticated.ts) for endpoints that requires authentication, or [apps/public.ts](apps/public.ts) for ones that is public API. Additionally, always add your service to [apps/loacl.ts](apps/local.ts) to allow local testing.