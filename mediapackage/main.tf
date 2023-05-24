resource "aws_media_package_channel" "bartek_channel" {
  channel_id  = "bartek-channel"
  description = "A channel created as part of Bartek's exercices."
}

output "media_package_channel_arn" {
  description = "The ARN of the MediaLive channel"
  value       = aws_media_package_channel.bartek_channel.arn
}
