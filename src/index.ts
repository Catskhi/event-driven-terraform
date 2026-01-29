import { DynamoDBClient } from '@aws-sdk/client-dynamodb'
import { DynamoDBDocumentClient, QueryCommand, PutCommand, UpdateCommand, DeleteCommand } from '@aws-sdk/lib-dynamodb'

export const handler = async (event) => {
    return {
        statusCode: 200,
        body: JSON.stringify({ message: "Hello, World!" }),
    }
}