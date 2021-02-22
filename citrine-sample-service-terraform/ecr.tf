resource "aws_ecr_repository" "punch_repository" {
  name                 = "punch/sample-service"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}