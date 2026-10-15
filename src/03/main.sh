#!/bin/bash
# shellcheck source-path=SCRIPTDIR

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

# Подключение файлов с функциями
source "$SCRIPT_DIR/collect_data.sh"
source "$SCRIPT_DIR/functions.sh"

# Список имен переменных для формирования отчета
params=(
    HOSTNAME TIMEZONE USER OS DATE 
    UPTIME UPTIME_SEC IP MASK GATEWAY 
    RAM_TOTAL RAM_USED RAM_FREE 
    SPACE_ROOT SPACE_ROOT_USED SPACE_ROOT_FREE
)

if ! check_param "$@"; then
    echo "Запустите скрипт повторно с четырьмя аргументами (цифры от 1-6)"
    exit 1
fi

# Сбор информации о системе
system_data
time_data
ip_config
ram_data
space_data

# Назначение цветов фона и текста
key_bg=$(get_color_code "$1" 40)
key_font=$(get_color_code "$2" 30)
val_bg=$(get_color_code "$3" 40)
val_font=$(get_color_code "$4" 30)

# Вывод отчета на экран
display_color_report "$key_bg" "$key_font" "$val_bg" "$val_font"
