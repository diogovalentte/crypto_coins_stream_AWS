output "elastic_search_domain_arn" {
    value = aws_elasticsearch_domain.elastic_search_domain.arn
}
output "kibana_endpoint" {
    value = aws_elasticsearch_domain.elastic_search_domain.kibana_endpoint
}