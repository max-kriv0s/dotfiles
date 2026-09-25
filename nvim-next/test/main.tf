// LSP: terraformls. Форматирование: terraform fmt. Линтер: tflint.
// Отступы ниже намеренно кривые — проверка форматирования при сохранении.

terraform {
  required_version = ">= 1.5"
}

variable "bucket_name" {
  type        = string
  description = "Имя бакета"
}

resource "local_file" "example" {
    filename = "${path.module}/example.txt"
  content  = "проверка"
}
