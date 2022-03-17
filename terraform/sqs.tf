#####ALPHA#####

resource "aws_sqs_queue" "datascraper_block" {
  name                        = "datascraper-block.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "datascraper_block_backwards" {
  name                        = "datascraper-block-backwards.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "datascraper_media" {
  name                        = "datascraper-media.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "datascraper_token" {
  name                        = "datascraper-token.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "datascraper_transfer" {
  name                        = "datascraper-transfer.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "datascraper_transfer_monitor" {
  name                        = "datascraper-transfer-monitor.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "datascraper_owner" {
  name                        = "datascraper-owner.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

#####DEV#####

resource "aws_sqs_queue" "rinkeby_datascraper_block" {
  name                        = "rinkeby-datascraper-block.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "rinkeby_datascraper_block_backwards" {
  name                        = "rinkeby-datascraper-block-backwards.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "rinkeby_datascraper_media" {
  name                        = "rinkeby-datascraper-media.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "rinkeby_datascraper_token" {
  name                        = "rinkeby-datascraper-token.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "rinkeby_datascraper_transfer" {
  name                        = "rinkeby-datascraper-transfer.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "rinkeby_datascraper_transfer_monitor" {
  name                        = "rinkeby-datascraper-transfer-monitor.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "rinkeby_datascraper_owner" {
  name                        = "rinkeby-datascraper-owner.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

#####PROD#####

resource "aws_sqs_queue" "prod_datascraper_block" {
  name                        = "prod-datascraper-block.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "prod_datascraper_block_backwards" {
  name                        = "prod-datascraper-block-backwards.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "prod_datascraper_media" {
  name                        = "prod-datascraper-media.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "prod_datascraper_token" {
  name                        = "prod-datascraper-token.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "prod_datascraper_transfer" {
  name                        = "prod-datascraper-transfer.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "prod_datascraper_transfer_monitor" {
  name                        = "prod-datascraper-transfer-monitor.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "prod_datascraper_owner" {
  name                        = "prod-datascraper-owner.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 600
  message_retention_seconds   = 1209600
}