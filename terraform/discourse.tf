## Discourse

resource "aws_lightsail_key_pair" "liviudm" {
  name       = "liviudm"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCld5TO0973pMXJfM2h4/1+h2zf9WzIJ8+qfgv5jAAM+Ertd42gtmD6SXO9oydfImaqfZvBvxkHPm00pIkicTrt+G+HvcDtx+h90JVagHHYTHn99H2jcNkMeYN/iAyIFRNAEiiITDRVBNsJE4Q5pWlxu6PopFaHjuS5ZPJwZPymV6VJliNF8Z6wGeUaOtdYoGrormVXmgUmYo3OUm6yF0gYVxpCrnr6YqY9D+aJTNWrRY018ltlYBvA8UQcxKfCvjOTUCtIeoffDbh09IBUTunLx5bThgE7Im9qgibea4qbDehfzdexSUHFBp/R1mhDg6d9sicjSmjQgw+nnrsdnyEop8GKA9+ZkjB1NS1dPyZj2hblei39p7SHjvhy0mSGQCqvlSkWBOi50rbADWYMgd/fh+MZmdSN9dqpKOaq0tAmJvUn+8KkcCQMR4310e0kI63bfwN5IutgTKbdg87hMpD0pTvSwQ0zsK+B93m4ocrY26MidXizdPTZ8pCA80nOz1NEJmAwxxSFpqbqp5uaglEqOu921YimNoQmB3Og5k2TI9mGB+4+5NCCDnF0C4grugMQdQdIkUZ7Di2jfNXPOG5l9yc7DzXXN4Gx9TgAy5cJBe9clLcOuY9AR8XBBZrUIKXKOMWE4wboyO8WYDGXIFKFHKYKtm/kpMoICclsDrIrQQ== liviudm@liviudm.local"
}

resource "aws_lightsail_instance" "discourse" {
  name              = "new-forum-universe-xyz"
  availability_zone = "us-east-1a"
  blueprint_id      = "ubuntu_20_04"
  bundle_id         = "medium_2_0"
  key_pair_name     = aws_lightsail_key_pair.liviudm.id

  tags = {
    Environment = "production"
  }
}

resource "aws_lightsail_static_ip" "discourse" {
  name = "discourse"
}

resource "aws_lightsail_static_ip_attachment" "discourse" {
  static_ip_name = aws_lightsail_static_ip.discourse.id
  instance_name  = aws_lightsail_instance.discourse.id
}

resource "aws_route53_record" "discourse" {
  zone_id = aws_route53_zone.main.id
  name    = "forum.universe.xyz"
  type    = "A"
  ttl     = "300"
  records = [aws_lightsail_static_ip.discourse.ip_address]
}

resource "aws_ses_domain_identity" "universe_xyz" {
  domain = "universe.xyz"
}

resource "aws_ses_domain_dkim" "universe_xyz" {
  domain = aws_ses_domain_identity.universe_xyz.domain
}

resource "aws_route53_record" "universe_xyz_ses_verification" {
  zone_id = aws_route53_zone.main.id
  name    = "_amazonses.universe_xyz"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.universe_xyz.verification_token]
}

resource "aws_route53_record" "universe_xyz_ses_dkim" {
  count   = 3
  zone_id = aws_route53_zone.main.id
  name    = "${element(aws_ses_domain_dkim.universe_xyz.dkim_tokens, count.index)}._domainkey.universe.xyz"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.universe_xyz.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

resource "aws_iam_user" "discourse_ses" {
  name = "discourse-ses"
  path = "/services/"
}

resource "aws_iam_user_policy" "discourse_ses_smtp" {
  name   = "AmazonSesSendingAccess"
  user   = aws_iam_user.discourse_ses.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ses:SendRawEmail",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_access_key" "discourse_ses" {
  user = aws_iam_user.discourse_ses.name
}

output "smtp_password" {
  sensitive = true
  value     = aws_iam_access_key.discourse_ses.ses_smtp_password_v4
}
