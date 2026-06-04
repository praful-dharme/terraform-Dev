data "aws_iam_role" "ssm_role" {
  name = "ec2-ssm-full-access"
}

resource "aws_iam_instance_profile" "ec2_profile" {

  name = "ec2-ssm-full-access-profile"

  role = data.aws_iam_role.ssm_role.name
}