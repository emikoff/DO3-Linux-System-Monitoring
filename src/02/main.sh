#!/bin/bash
# shellcheck source-path=SCRIPTDIR

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

# Проверка отсутствия аргументов командной строки
if [[ $# -ne 0 ]]; then
    echo "Ошибка: скрипт не принимает параметры."
    exit 1
fi

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

# Сбор информации о системе
system_data
time_data
ip_config
ram_data
space_data

# Формирование отчета
build_report
# Вывод отчета на экран
display_report
# Предлагает сохранить отчет в файл
ask_to_save
