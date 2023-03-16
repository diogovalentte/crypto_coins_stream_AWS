s3_bucket_name = "crypto-1ar49bdfg987olkp"
s3_bucket_prefix = "crypto_coins_data/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
s3_bucket_error_prefix = "crypto_coins_error/!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"