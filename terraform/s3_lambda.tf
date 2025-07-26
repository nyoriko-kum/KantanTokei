module "s3_lambda" {
    source        = "./modules/s3_public_deny"
    bucket_prefix = "lambda-source"
    enable_versioning = true  # 明示的に有効化
}

resource "aws_s3_object" "lambda_zip" {
  bucket = module.s3_lambda.bucket_id
  key    = "test/latest.zip"
  source = "./latest.zip" 
  etag = filemd5("./latest.zip")
}

resource "aws_iam_role" "lambda_exec" {
  name = "main-func-lambda-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ロールの設定
resource "aws_iam_role_policy" "lambda_s3_access" {
  name = "LambdaS3Access"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      Resource = [
        "arn:aws:s3:::${module.s3_lambda.bucket_id}",
        "arn:aws:s3:::${module.s3_lambda.bucket_id}/*"
      ]
    }]
  })
}


# "aws_s3_bucket_policy"でアタッチもしてくれる。直接紐づけてくれる。
resource "aws_s3_bucket_policy" "allow_lambda_getobject" {
  bucket = module.s3_lambda.bucket_id
  # バケットポリシーの設定
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
     # Sid:「LambdaユーザーにGetObject権限を与えるステートメント」というラベルを付けている
        Sid = "AllowLambdaUserToGetObjects"
        Effect = "Allow"
        Principal = {
          AWS = [
            aws_iam_role.lambda_exec.arn,
            # ここがポイント！！
            "arn:aws:iam::668567157532:user/developper"
          ]
        }
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${module.s3_lambda.bucket_arn}",
          "${module.s3_lambda.bucket_arn}/*"
        ]
      }
    ]
  })
}

output "lambda_exec_role_arn" {
  value = aws_iam_role.lambda_exec.arn  
}

output "allow_lambda_policy" {
  value = aws_s3_bucket_policy.allow_lambda_getobject.policy
}

output "lambda_s3_access" {
  value = aws_iam_role_policy.lambda_s3_access.role
}