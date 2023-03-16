output "firehose_role_arn" {
    value = module.firehose.firehose_role_arn
}
output "kibana_endpoint" {
    value = module.elastic_search.kibana_endpoint
}