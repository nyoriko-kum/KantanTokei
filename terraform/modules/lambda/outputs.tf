# 現在のリージョンを取得
data "aws_region" "current" {}
# 名前を出力
output "lambda_arn" { value = aws_lambda_function.lambda_function.arn }
# Invoke ARN （Lambdaの呼び出しに使う完全なARN）を出力
output "invoke_arn"   { value = aws_lambda_function.lambda_function.invoke_arn }
# マネコンのリンクURLを出力
output "console_link" {
  value = "https://${data.aws_region.current.id}.console.aws.amazon.com/lambda/home#/functions/${aws_lambda_function.lambda_function.function_name}"
}