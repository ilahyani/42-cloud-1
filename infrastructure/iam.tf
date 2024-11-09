resource "aws_iam_user" "gf_user" {
  name = "grafana_user"
}

resource "aws_iam_policy" "gf_policy" {
    name = "grafana_iam_policy"
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AllowReadingMetricsFromCloudWatch",
                "Effect": "Allow",
                "Action": [
                    "cloudwatch:DescribeAlarmsForMetric",
                    "cloudwatch:DescribeAlarmHistory",
                    "cloudwatch:DescribeAlarms",
                    "cloudwatch:ListMetrics",
                    "cloudwatch:GetMetricData",
                    "cloudwatch:GetInsightRuleReport"
                ],
                "Resource": "*"
            },
            {
                "Sid": "AllowReadingLogsFromCloudWatch",
                "Effect": "Allow",
                "Action": [
                    "logs:DescribeLogGroups",
                    "logs:GetLogGroupFields",
                    "logs:StartQuery",
                    "logs:StopQuery",
                    "logs:GetQueryResults",
                    "logs:GetLogEvents"
                ],
                "Resource": "*"
            },
            {
                "Sid": "AllowReadingTagsInstancesRegionsFromEC2",
                "Effect": "Allow",
                "Action": [
                    "ec2:DescribeTags",
                    "ec2:DescribeInstances",
                    "ec2:DescribeRegions"
                ],
                "Resource": "arn:aws:ec2:*:*:instance/*"
            },
            {
                "Sid": "AllowReadingResourcesForTags",
                "Effect": "Allow",
                "Action": "tag:GetResources",
                "Resource": "arn:aws:ec2:*:*:instance/*"
            }
        ]
    })
}

resource "aws_iam_user_policy_attachment" "gf_user_policy_attachment" {
  user       = aws_iam_user.gf_user.name
  policy_arn = aws_iam_policy.gf_policy.arn
}

resource "aws_iam_access_key" "gf_user_access_key" {
  user = aws_iam_user.gf_user.name
}

output "access_key_id" {
  value = aws_iam_access_key.gf_user_access_key.id
}

output "secret_access_key" {
  value = aws_iam_access_key.gf_user_access_key.secret
  sensitive = true
}
