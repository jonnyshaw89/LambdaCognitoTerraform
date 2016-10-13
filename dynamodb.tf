// DynamoDB

resource "aws_dynamodb_table" "users-table" {
    name = "Users"
    read_capacity = 1
    write_capacity = 1
    hash_key = "email"
    attribute {
        name = "email"
        type = "S"
    }
}