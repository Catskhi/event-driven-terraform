import { DynamoDBClient } from '@aws-sdk/client-dynamodb'
import { DynamoDBDocumentClient, QueryCommand, PutCommand, UpdateCommand, DeleteCommand } from '@aws-sdk/lib-dynamodb'
import type { APIGatewayProxyEventV2 } from 'aws-lambda'

const client = new DynamoDBClient({})
const ddbDocClient = DynamoDBDocumentClient.from(client)
const table_name = process.env.TABLE_NAME!

export const handler = async (event: APIGatewayProxyEventV2) => {
    const method: string = event.requestContext.http.method;
    const user_id: string = event.requestContext.authorizer?.jwt?.claims?.sub as string
    const body = JSON.parse(event.body || '{}')
    switch (method) {
        case "GET": {
            const result = await ddbDocClient.send(new QueryCommand({
                TableName: table_name,
                KeyConditionExpression: "user_id = :uid",
                ExpressionAttributeValues: {
                    ":uid": user_id
                }
            }))
            return {
                statusCode: 200,
                body: JSON.stringify({ tasks: result.Items}),
            }
        }
        case "POST": {
            await ddbDocClient.send(new PutCommand({
                TableName: table_name,
                Item: {
                    user_id: user_id,
                    task_id: crypto.randomUUID(),
                    title: body.title,
                    created_at: new Date().toISOString()
                }
            }))
            return {
                statusCode: 201,
                body: JSON.stringify({ message: "Task created." }),
            }
        }
        case "PUT": {
            const task_id = event.pathParameters?.id;
            await ddbDocClient.send(new UpdateCommand({
                TableName: table_name,
                Key: {
                    user_id: user_id,
                    task_id: task_id
                },
                UpdateExpression: "SET title = :title, updated_at = :updated_at",
                ExpressionAttributeValues: {
                    ":title": body.title,
                    ":updated_at": new Date().toISOString()
                }
            }))
            return {
                statusCode: 200,
                body: JSON.stringify({ message: "Task updated" }),
            }
        }
        case "DELETE": {
            const task_id = event.pathParameters?.id;
            await ddbDocClient.send(new DeleteCommand({
                TableName: table_name,
                Key: {
                    user_id: user_id,
                    task_id: task_id
                }
            }))
            return {
                statusCode: 204,
                body: JSON.stringify({ message: "Deleting Task" }),
            }
        }
        default: {
            return {
                statusCode: 405,
                body: JSON.stringify({ message: "Method Not Allowed" }),
            }
        }
    }
}