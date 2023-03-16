output "firehose_stream_arn" {
    value = aws_kinesis_firehose_delivery_stream.firehose_stream.arn
}
output "firehose_role_arn" {
    value = aws_iam_role.firehose_role.arn
}