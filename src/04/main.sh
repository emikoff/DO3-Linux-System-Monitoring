#!/bin/bash
# shellcheck source-path=SCRIPTDIR

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

# Проверяем отсутствие параметров на вводе
if [[ $# -ne 0 ]]; then
    echo "Ошибка: скрипт не принимает параметры."
    exit 1
fi

# Подключение файлов с функциями
source "$SCRIPT_DIR/collect_data.sh"
source "$SCRIPT_DIR/functions.sh"
source "$SCRIPT_DIR/settings.conf"

# Список имен переменных для формирования отчета
params=(
    HOSTNAME TIMEZONE USER OS DATE 
    UPTIME UPTIME_SEC IP MASK GATEWAY 
    RAM_TOTAL RAM_USED RAM_FREE 
    SPACE_ROOT SPACE_ROOT_USED SPACE_ROOT_FREE
)

# цветовой профиль по умолчанию
# (1 — white, 2 — red, 3 — green, 4 — blue, 5 – purple, 6 — black)
DEFAULT_COL1_BG=1
DEFAULT_COL1_FONT=6
DEFAULT_COL2_BG=2
DEFAULT_COL2_FONT=4

# Загрузка цветового профиля из конфига
col1_bg=${column1_background:-$DEFAULT_COL1_BG}
col1_font=${column1_font_color:-$DEFAULT_COL1_FONT}
col2_bg=${column2_background:-$DEFAULT_COL2_BG}
col2_font=${column2_font_color:-$DEFAULT_COL2_FONT}

if ! check_param "$col1_bg" "$col1_font" "$col2_bg" "$col2_font"; then
    echo "Измените настройки в settings.conf и перезапустите скрипт."
    exit 1
fi

# Назначение цветов фона и текста
key_bg=$(get_color_code "${col1_bg}" 40)
key_font=$(get_color_code "${col1_font}" 30)
val_bg=$(get_color_code "${col2_bg}" 40)
val_font=$(get_color_code "${col2_font}" 30)

# Сбор информации о системе
system_data
time_data
ip_config
ram_data
space_data

# Вывод отчета на экран
display_color_report "$key_bg" "$key_font" "$val_bg" "$val_font"
# Вывод цветового профиля
config_color "$col1_bg" "$col1_font" "$col2_bg" "$col2_font"
