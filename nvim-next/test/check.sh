#!/usr/bin/env bash
# LSP: bashls. Форматирование: shfmt. Линтер: shellcheck.
# Переменная ниже без кавычек — shellcheck должен предупредить (SC2086).

set -euo pipefail

target_dir=$1

count_files() {
  local dir=$1
  find $dir -type f | wc -l
}

echo "Файлов в каталоге: $(count_files "$target_dir")"
