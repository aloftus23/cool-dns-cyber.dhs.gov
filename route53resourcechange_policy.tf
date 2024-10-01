# ------------------------------------------------------------------------------
# Create the IAM policy that allows all of the route53 actions necessary to create and
# modify resource records in the cyber.dhs.gov zone.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "route53resourcechange_doc" {
  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:GetHostedZone",
      "route53:ListResourceRecordSets",
    ]

    resources = ["arn:aws:route53:::hostedzone/${aws_route53_zone.cyber_dhs_gov.id}"]
  }

  statement {
    actions = [
      "route53:GetChange"
    ]

    resources = ["arn:aws:route53:::change/*"]
  }

  statement {
    actions = [
      "route53:ListHostedZones"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ses:DeleteIdentity",
      "ses:GetAccount",
      "ses:GetIdentityDkimAttributes",
      "ses:GetIdentityMailFromDomainAttributes",
      "ses:GetIdentityNotificationAttributes",
      "ses:GetIdentityVerificationAttributes",
      "ses:PutAccountVdmAttributes",
      "ses:SetIdentityHeadersInNotificationsEnabled",
      "ses:SetIdentityMailFromDomain",
      "ses:SetIdentityNotificationTopic",
      "ses:VerifyDomainDkim",
      "ses:VerifyDomainIdentity",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "sns:*",
    ]

    resources = [
      "arn:aws:sns:${var.aws_region}:${local.dns_account_id}:cyber_dhs_gov_bounce",
      "arn:aws:sns:${var.aws_region}:${local.dns_account_id}:cyber_dhs_gov_complaint",
      "arn:aws:sns:${var.aws_region}:${local.dns_account_id}:cyber_dhs_gov_delivery",
    ]
  }

  statement {
    actions = [
      "sqs:*",
    ]

    resources = [
      "arn:aws:sqs:${var.aws_region}:${local.dns_account_id}:cyber_dhs_gov_delivery",
    ]
  }
}

resource "aws_iam_policy" "route53resourcechange_policy" {
  provider = aws.dnsprovisionaccount

  description = var.route53resourcechange_role_description
  name        = var.route53resourcechange_role_name
  policy      = data.aws_iam_policy_document.route53resourcechange_doc.json
}
