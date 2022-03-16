#####ALPHA#####

resource "aws_sqs_queue" "datascraper_block" {
  name                        = "datascraper-block.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
  depends_on                  = [aws_sqs_queue.datascraper_block_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.datascraper_block_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "datascraper_block_dlq" {
  name                        = "datascraper-block-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "datascraper_block_backwards" {
  name                        = "datascraper-block-backwards.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
  depends_on                  = [aws_sqs_queue.datascraper_block_backwards_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.datascraper_block_backwards_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "datascraper_block_backwards_dlq" {
  name                        = "datascraper-block-backwards-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "datascraper_media" {
  name                        = "datascraper-media.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
  depends_on                  = [aws_sqs_queue.datascraper_media_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.datascraper_media_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "datascraper_media_dlq" {
  name                        = "datascraper-media-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "datascraper_token" {
  name                        = "datascraper-token.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
  depends_on                  = [aws_sqs_queue.datascraper_token_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.datascraper_token_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "datascraper_token_dlq" {
  name                        = "datascraper-token-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
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
  depends_on                  = [aws_sqs_queue.datascraper_transfer_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.datascraper_transfer_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "datascraper_transfer_dlq" {
  name                        = "datascraper-transfer-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
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
  depends_on                  = [aws_sqs_queue.datascraper_transfer_monitor_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.datascraper_transfer_monitor_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "datascraper_transfer_monitor_dlq" {
  name                        = "datascraper-transfer-monitor-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
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
  depends_on                  = [aws_sqs_queue.datascraper_owner_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.datascraper_owner_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "datascraper_owner_dlq" {
  name                        = "datascraper-owner-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
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
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
  depends_on                  = [aws_sqs_queue.rinkeby_datascraper_block_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.rinkeby_datascraper_block_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "rinkeby_datascraper_block_dlq" {
  name                        = "rinkeby-datascraper-block-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "rinkeby_datascraper_block_backwards" {
  name                        = "rinkeby-datascraper-block-backwards.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
  depends_on                  = [aws_sqs_queue.rinkeby_datascraper_block_backwards_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.rinkeby_datascraper_block_backwards_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "rinkeby_datascraper_block_backwards_dlq" {
  name                        = "rinkeby-datascraper-block-backwards-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "rinkeby_datascraper_media" {
  name                        = "rinkeby-datascraper-media.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
  depends_on                  = [aws_sqs_queue.rinkeby_datascraper_media_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.rinkeby_datascraper_media_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "rinkeby_datascraper_media_dlq" {
  name                        = "rinkeby-datascraper-media-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "rinkeby_datascraper_token" {
  name                        = "rinkeby-datascraper-token.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
  depends_on                  = [aws_sqs_queue.rinkeby_datascraper_token_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.rinkeby_datascraper_token_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "rinkeby_datascraper_token_dlq" {
  name                        = "rinkeby-datascraper-token-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "rinkeby_datascraper_transfer" {
  name                        = "rinkeby-datascraper-transfer.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
  depends_on                  = [aws_sqs_queue.rinkeby_datascraper_transfer_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.rinkeby_datascraper_transfer_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "rinkeby_datascraper_transfer_dlq" {
  name                        = "rinkeby-datascraper-transfer-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "rinkeby_datascraper_transfer_monitor" {
  name                        = "rinkeby-datascraper-transfer-monitor.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
  depends_on                  = [aws_sqs_queue.rinkeby_datascraper_transfer_monitor_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.rinkeby_datascraper_transfer_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "rinkeby_datascraper_transfer_monitor_dlq" {
  name                        = "rinkeby-datascraper-transfer-monitor-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "rinkeby_datascraper_owner" {
  name                        = "rinkeby-datascraper-owner.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
  depends_on                  = [aws_sqs_queue.rinkeby_datascraper_owner_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.rinkeby_datascraper_owner_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "rinkeby_datascraper_owner_dlq" {
  name                        = "rinkeby-datascraper-owner-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
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
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
  depends_on                  = [aws_sqs_queue.prod_datascraper_block_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.prod_datascraper_block_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "prod_datascraper_block_dlq" {
  name                        = "prod-datascraper-block-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "prod_datascraper_block_backwards" {
  name                        = "prod-datascraper-block-backwards.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
  depends_on                  = [aws_sqs_queue.prod_datascraper_block_backwards_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.prod_datascraper_block_backwards_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "prod_datascraper_block_backwards_dlq" {
  name                        = "prod-datascraper-block-backwards-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "prod_datascraper_media" {
  name                        = "prod-datascraper-media.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
  depends_on                  = [aws_sqs_queue.prod_datascraper_media_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.prod_datascraper_media_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "prod_datascraper_media_dlq" {
  name                        = "prod-datascraper-media-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "prod_datascraper_token" {
  name                        = "prod-datascraper-token.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
  depends_on                  = [aws_sqs_queue.prod_datascraper_token_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.prod_datascraper_token_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "prod_datascraper_token_dlq" {
  name                        = "prod-datascraper-token-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "prod_datascraper_transfer" {
  name                        = "prod-datascraper-transfer.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
  depends_on                  = [aws_sqs_queue.prod_datascraper_transfer_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.prod_datascraper_transfer_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "prod_datascraper_transfer_dlq" {
  name                        = "prod-datascraper-transfer-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "prod_datascraper_transfer_monitor" {
  name                        = "prod-datascraper-transfer-monitor.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
  depends_on                  = [aws_sqs_queue.prod_datascraper_transfer_monitor_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.prod_datascraper_transfer_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "prod_datascraper_transfer_monitor_dlq" {
  name                        = "prod-datascraper-transfer-monitor-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
}

resource "aws_sqs_queue" "prod_datascraper_owner" {
  name                        = "prod-datascraper-owner.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
  depends_on                  = [aws_sqs_queue.prod_datascraper_owner_dlq]
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.prod_datascraper_owner_dlq.arn
    maxReceiveCount     = 1000
  })
}

resource "aws_sqs_queue" "prod_datascraper_owner_dlq" {
  name                        = "prod-datascraper-owner-dlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
  message_retention_seconds   = 1209600
}