data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["medialive.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_s3_bucket" "main" {
  bucket = "bartek-test-bucket-1"
  acl    = "private"
  tags = {
    Name = "bartek-test-bucket-2"
  }
}

resource "aws_s3_bucket" "main2" {
  bucket = "bartek-test-bucket-2"
  acl    = "private"
  tags = {
    Name = "bartek-test-bucket-2"
  }
}

resource "aws_medialive_input_security_group" "example" {
  whitelist_rules {
    cidr = "10.0.0.8/32"
  }
}

resource "aws_medialive_input" "example" {
  name                  = "example-input"
  input_security_groups = [aws_medialive_input_security_group.example.id]
  type                  = "UDP_PUSH"

}

resource "aws_iam_role" "iam_for_medialive" {
  name               = "iam_for_medialive"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}



resource "aws_medialive_channel" "bartek_example" {
  name          = "bartek_example-channel"
  channel_class = "STANDARD"
  role_arn      = aws_iam_role.iam_for_medialive.arn

  input_specification {
    codec            = "MPEG2"
    input_resolution = "HD"
    maximum_bitrate  = "MAX_20_MBPS"
  }

  input_attachments {
    input_attachment_name = "example-input"
    input_id              = aws_medialive_input.example.id

  }

  destinations {
    id = "destination"

    settings {
      url = "s3://${aws_s3_bucket.main.id}/test1"
    }

    settings {
      url = "s3://${aws_s3_bucket.main2.id}/test2"
    }
  }

  encoder_settings {
    timecode_config {
      source = "EMBEDDED"
    }

    audio_descriptions {
      audio_selector_name = "example audio selector"
      name                = "audio-selector"
    }

    video_descriptions {
      name = "example-video"
    }

    output_groups {
      output_group_settings {
        archive_group_settings {
          destination {
            destination_ref_id = "destination"
          }
        }
      }

      outputs {
        output_name             = "example-name"
        video_description_name  = "example-video"
        audio_description_names = ["audio-selector"]
        output_settings {
          archive_output_settings {
            name_modifier = "_1"
            extension     = "m2ts"
            container_settings {
              m2ts_settings {
                audio_buffer_model = "ATSC"
                buffer_model       = "MULTIPLEX"
                rate_mode          = "CBR"
              }
            }
          }
        }
      }
    }
  }
}


output "aws_medialive_channel_arn" {
  description = "The ARN of the Channel"
  value       = aws_medialive_channel.bartek_example.arn
}
