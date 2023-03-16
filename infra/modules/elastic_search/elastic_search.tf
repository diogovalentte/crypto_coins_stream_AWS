resource "aws_elasticsearch_domain" "elastic_search_domain" {
  domain_name    = var.elastic_search_domain_name
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = var.elastic_search_instance_type
    instance_count = var.elastic_search_instance_count
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled = true
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.elastic_search_ebs_size
  }

  domain_endpoint_options {
    enforce_https = true
    tls_security_policy = "Policy-Min-TLS-1-0-2019-07"
  }

  advanced_security_options {
    enabled = true
    internal_user_database_enabled = true
    master_user_options {
      master_user_name = var.elastic_search_master_user_name
      master_user_password = var.elastic_search_master_password
    }
  }

  access_policies = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: {
          AWS: "*"
        },
        Action: "es:*",
        Resource: "*"
      }
    ]
  })
}
