terraform {
  required_version = "0.12.1"
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "brycedev"

    workspaces {
      prefix = "mbrycedev_"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  version = "~> 2.49.0"
  region  = "us-east-1"
}

# resource "aws_iam_policy" "DenyAllNoMFA" {
#   name        = "DenyAllNoMFA"
#   path        = "/"
#   description = "This policy explicitly denies all actions in AWS unless MFA login has been done. And will be required for all User Groups."
#   policy      = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "AllowViewAccountInfo",
#       "Effect": "Allow",
#       "Action": "iam:ListVirtualMFADevices",
#       "Resource": "*"
#     },
#     {
#       "Sid": "AllowManageOwnVirtualMFADevice",
#       "Effect": "Allow",
#       "Action": [
#         "iam:CreateVirtualMFADevice",
#         "iam:DeleteVirtualMFADevice"
#       ],
#       "Resource": "arn:aws:iam::*:mfa/$${aws:username}"
#     },
#     {
#       "Sid": "AllowManageOwnUserMFA",
#       "Effect": "Allow",
#       "Action": [
#         "iam:DeactivateMFADevice",
#         "iam:EnableMFADevice",
#         "iam:GetUser",
#         "iam:ListMFADevices",
#         "iam:ResyncMFADevice"
#       ],
#       "Resource": "arn:aws:iam::*:user/$${aws:username}"
#     },
#     {
#       "Sid": "DenyAllExceptListedIfNoMFA",
#       "Effect": "Deny",
#       "NotAction": [
#         "iam:CreateVirtualMFADevice",
#         "iam:EnableMFADevice",
#         "iam:GetUser",
#         "iam:ListMFADevices",
#         "iam:ListVirtualMFADevices",
#         "iam:ResyncMFADevice",
#         "sts:GetSessionToken"
#       ],
#       "Resource": "*",
#       "Condition": {
#         "BoolIfExists": {
#           "aws:MultiFactorAuthPresent": "false"
#         }
#       }
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_policy_attachment" "DenyAllNoMFA-policy-attachment" {
#   name       = "DenyAllNoMFA-policy-attachment"
#   policy_arn = "arn:aws:iam::795563484616:policy/DenyAllNoMFA"
#   groups     = ["Admins"]
#   users      = []
#   roles      = []
# }

# resource "aws_iam_policy_attachment" "AdministratorAccess-policy-attachment" {
#   name       = "AdministratorAccess-policy-attachment"
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
#   groups     = ["Admins"]
#   users      = []
#   roles      = []
# }

# resource "aws_route53_record" "mbryce-dev-MX" {
#   zone_id = "Z1LHCRSSW1G148"
#   name    = "mbryce.dev"
#   type    = "MX"
#   records = ["1 	ASPMX.L.GOOGLE.COM.", "5 	ALT1.ASPMX.L.GOOGLE.COM.", "5 	ALT2.ASPMX.L.GOOGLE.COM.", "10 	ALT3.ASPMX.L.GOOGLE.COM.", "10 	ALT4.ASPMX.L.GOOGLE.COM."]
#   ttl     = "300"
# }

# resource "aws_route53_record" "mbryce-dev-NS" {
#   zone_id = "Z1LHCRSSW1G148"
#   name    = "mbryce.dev"
#   type    = "NS"
#   records = ["ns-2015.awsdns-59.co.uk.", "ns-213.awsdns-26.com.", "ns-1103.awsdns-09.org.", "ns-744.awsdns-29.net."]
#   ttl     = "172800"
# }

# resource "aws_route53_record" "mbryce-dev-SOA" {
#   zone_id = "Z1LHCRSSW1G148"
#   name    = "mbryce.dev"
#   type    = "SOA"
#   records = ["ns-2015.awsdns-59.co.uk. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
#   ttl     = "900"
# }

# resource "aws_route53_record" "mbryce-dev-TXT" {
#   zone_id = "Z1LHCRSSW1G148"
#   name    = "mbryce.dev"
#   type    = "TXT"
#   records = ["\"google-site-verification=UXQ_7o2r7EoiR9y9gGqKk4pXP3v6NDQcbk8dZhXeqAk\""]
#   ttl     = "300"
# }

# resource "aws_route53_record" "_5c9c036f8b2b445aed4e78ee3292327c-mbryce-dev-CNAME" {
#   zone_id = "Z1LHCRSSW1G148"
#   name    = "_5c9c036f8b2b445aed4e78ee3292327c.mbryce.dev"
#   type    = "CNAME"
#   records = ["_aa6379ebbaa6b70d77d987af2b391795.kirrbxfjtw.acm-validations.aws."]
#   ttl     = "300"
# }

# resource "aws_route53_zone" "mbryce-dev-public" {
#   name    = "mbryce.dev"
#   comment = ""
# }

resource "aws_iam_policy" "test_policy" {
  name        = "test_policy"
  path        = "/"
  description = "My test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
