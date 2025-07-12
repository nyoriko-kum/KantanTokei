#ここの変数は、大本のmain.tfで呼んだときに名前を定義して入れることができる変数の定義
# 基本的にモジュール内のmain.tfには、function_name = var.function_nameみたいに書く。
variable "function_name" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
  default = "python3.9"
}

variable "role_arn" {
  type = string
}

variable "s3_key" {
  type = string
}

# S3にアップロードされたZIPファイルの 特定のバージョン を指定するために使う
variable "s3_object_version" {
  type    = string
  # Nullだと最新バージョンが使われる。＝省略可能。
  default = null
}

variable "s3_bucket" {
  type = string
}
