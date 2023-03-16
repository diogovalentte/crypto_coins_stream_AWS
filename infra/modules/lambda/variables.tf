variable "lambda_name" {
  type = string
}
variable "lambda_role_name" {
  type = string
}
variable "lambda_role_policy_name" {
  type = string
}
variable "lambda_layer_name" {
  type = string
}

variable "firehose_stream_name" {
    type = string
}
variable "firehose_stream_arn" {
  type = string
}