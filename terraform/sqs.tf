resource "aws_sqs_queue" "datascraper_block" {
  name                        = "datascraper-block.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
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
}

resource "aws_sqs_queue" "datascraper_media" {
  name                        = "datascraper-media.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
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
}

resource "aws_sqs_queue" "datascraper_token" {
  name                        = "datascraper-token.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
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
}

resource "aws_sqs_queue" "datascraper_transfer" {
  name                        = "datascraper-transfer.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  sqs_managed_sse_enabled     = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  visibility_timeout_seconds  = 180
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
}
