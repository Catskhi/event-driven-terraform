# Serverless Tasks API

A serverless CRUD API built on AWS with Terraform. Features JWT authentication via Cognito, Lambda functions, and DynamoDB storage.

## Architecture

```
                         ┌─────────────┐
                         │   Cognito   │
                         │  (JWT Auth) │
                         └──────┬──────┘
                                │
┌──────────┐    HTTPS    ┌──────┴──────┐    ┌──────────┐    ┌──────────┐
│  Client  │ ──────────▶ │ API Gateway │ ──▶│  Lambda  │ ──▶│ DynamoDB │
└──────────┘             └─────────────┘    └──────────┘    └──────────┘
```

## Tech Stack

- **Infrastructure**: Terraform
- **Runtime**: AWS Lambda (Node.js 20.x)
- **Database**: DynamoDB
- **API**: API Gateway HTTP API
- **Auth**: Cognito User Pool (JWT)
- **Build**: Bun

## Prerequisites

- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [Bun](https://bun.sh/) >= 1.0

## Setup

### 1. Install dependencies

```bash
cd src
bun install
```

### 2. Build Lambda

```bash
bun run build
```

### 3. Deploy infrastructure

```bash
cd terraform
terraform init
terraform apply
```

### 4. Note the outputs

```
cognito_client_id    = "xxx"
cognito_user_pool_id = "xxx"
dynamodb_table_name  = "xxx"
output_url           = "https://xxx.execute-api.us-east-1.amazonaws.com/dev"
```

## API Endpoints

All endpoints require JWT authentication via `Authorization: Bearer <token>` header.

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/tasks` | List all tasks for user |
| POST | `/tasks` | Create a new task |
| PUT | `/tasks/{id}` | Update a task |
| DELETE | `/tasks/{id}` | Delete a task |

### Request/Response Examples

**Create Task**
```bash
curl -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title": "My task"}' \
  $API_URL/tasks
```

**List Tasks**
```bash
curl -H "Authorization: Bearer $TOKEN" $API_URL/tasks
```

**Update Task**
```bash
curl -X PUT \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title": "Updated title"}' \
  $API_URL/tasks/{task_id}
```

**Delete Task**
```bash
curl -X DELETE \
  -H "Authorization: Bearer $TOKEN" \
  $API_URL/tasks/{task_id}
```

## Authentication

### Create a user

```bash
aws cognito-idp sign-up \
  --client-id $CLIENT_ID \
  --username your@email.com \
  --password YourPassword123!
```

### Confirm user (admin)

```bash
aws cognito-idp admin-confirm-sign-up \
  --user-pool-id $USER_POOL_ID \
  --username your@email.com
```

### Get JWT token

```bash
aws cognito-idp initiate-auth \
  --client-id $CLIENT_ID \
  --auth-flow USER_PASSWORD_AUTH \
  --auth-parameters USERNAME=your@email.com,PASSWORD=YourPassword123!
```

Use the `IdToken` from the response as your Bearer token.

## Project Structure

```
.
├── src/
│   ├── index.ts          # Lambda handler
│   └── package.json
├── terraform/
│   ├── providers.tf      # AWS provider config
│   ├── variables.tf      # Input variables
│   ├── dynamodb.tf       # DynamoDB table
│   ├── iam.tf            # IAM roles and policies
│   ├── lambda.tf         # Lambda function
│   ├── api_gateway.tf    # API Gateway routes
│   ├── cognito.tf        # User pool and client
│   ├── outputs.tf        # Output values
│   └── data.tf           # Archive for Lambda zip
├── test-api.sh           # API test script
└── README.md
```

## Cleanup

To destroy all resources:

```bash
cd terraform
terraform destroy
```
