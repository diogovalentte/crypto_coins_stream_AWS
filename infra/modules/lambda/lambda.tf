resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "resources/lambda/layer/lambda_layer_payload.zip"
  layer_name = var.lambda_layer_name

  compatible_runtimes = ["python3.9"]
}

resource "aws_iam_role" "role_for_lambda" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Action: "sts:AssumeRole",
        Principal: {
          Service: "lambda.amazonaws.com"
        },
        Effect: "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_role_policy" {
  name        = var.lambda_role_policy_name
  path        = "/"
  description = "Policy to a Lambda function put records on firehose stream"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "firehose:PutRecord",
          "firehose:PutRecordBatch",
          "firehose:ListTagsForDeliveryStream",
          "firehose:ListDeliveryStreams"
        ]
        Effect   = "Allow"
        Resource = var.firehose_stream_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_lambda_rule_policy" {
  role       = aws_iam_role.role_for_lambda.name
  policy_arn = aws_iam_policy.lambda_role_policy.arn
}

resource "aws_lambda_function" "lambda_func" {
  filename      = "resources/lambda/function/get_crypto_data.zip"
  function_name = var.lambda_name
  role          = aws_iam_role.role_for_lambda.arn
  handler       = "get_crypto_data.lambda_handler"
  layers = [aws_lambda_layer_version.lambda_layer.arn]

  source_code_hash = filebase64sha256("resources/lambda/function/get_crypto_data.zip")

  runtime = "python3.9"

  environment {
    variables = {
      DeliveryStreamName = var.firehose_stream_name
    }
  }
}