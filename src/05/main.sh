#!/bin/bash
# shellcheck source-path=SCRIPTDIR

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

# Подключение файлов с функциями
source "$SCRIPT_DIR/validate.sh"
source "$SCRIPT_DIR/collect_data.sh"
source "$SCRIPT_DIR/functions.sh"

if [ $# -ne 1 ]; then
    echo "Ошибка: требуется передать ровно 1 параметр, например /var/log/."
    exit 1
fi

# Проверка пути
validate_path "$1"

path="$1"
start_time=$(date +%s.%N)

collect_data "$path"

print_total_folders "$total_folders"
print_top_folders "$path" 5
print_total_files "$total_files"
print_data_files "$conf_files" "$txt_files" "$exe_files" "$log_files" "$archive_files" "$link_files"
print_top_files "$path" 10
print_top_exe_files "$path" 10

end_time=$(date +%s.%N)
print_execution_time "$start_time" "$end_time"
