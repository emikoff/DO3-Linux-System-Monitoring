#!/usr/bin/env bash

# Выводит строки отчета в цветном формате "ИМЯ = ЗНАЧЕНИЕ"
display_color_report() {
    local key_bg="$1"
    local key_font="$2"
    local val_bg="$3"
    local val_font="$4"

    local color_key="\033[${key_bg};${key_font}m"
    local color_val="\033[${val_bg};${val_font}m"
    local reset_color="\033[0m"

    for key in "${params[@]}"; do
        # ${!key} — косвенная ссылка: позволяет получить значение переменной,
        # имя которой хранится в переменной key.
        local val=${!key}

        echo -e "${color_key}${key}${reset_color} = ${color_val}$val${reset_color}"
    done
}

# Аргументы: $1 - индекс (1-6), $2 - база (30 или 40)
# (1 — white, 2 — red, 3 — green, 4 — blue, 5 – purple, 6 — black)
get_color_code() {
    local index=$1
    local base=$2
    local offset

    case "$index" in
        1) offset=7 ;; # white
        2) offset=1 ;; # red
        3) offset=2 ;; # green
        4) offset=4 ;; # blue
        5) offset=5 ;; # purple
        6) offset=0 ;; # black
    esac

    echo $((base + offset))
}

# Проверка корректности входных параметров
check_param () {
    local flag
    flag=0
        
    # Проверяет, что аргументы являются числами и находятся в диапазоне 1-6
    for arg in "$@"; do
        # Проверка: только цифры (регулярное выражение)
        if [[ ! "$arg" =~ ^[0-9]+$ ]]; then
            echo "Ошибка: '$arg' не является числом!"
            flag=1

        # Проверка: диапазон 1-6
        elif [[ "$arg" -lt 1 ]] || [[ "$arg" -gt 6 ]]; then
            echo "Ошибка: цифра $arg вне диапазона 1-6!"
            flag=1
        fi
    done
    
    # Сравнивает цвета только после успешной проверки формата.
    if [[ "$flag" -eq 0 ]]; then
        if [[ "$1" == "$2" ]]; then
            echo "Ошибка: цвета текста и фона для первого столбца совпадают!"
            flag=1
        fi

        if [[ "$3" == "$4" ]]; then
            echo "Ошибка: цвета текста и фона для второго столбца совпадают!"
            flag=1
        fi
    fi
    
    return $flag
}

# Информация о конфигурации
config_color() {
    echo
    echo "Column 1 background = ${column1_background:-default} ($(color "${1}"))"
    echo "Column 1 font color = ${column1_font_color:-default} ($(color "${2}"))"
    echo "Column 2 background = ${column2_background:-default} ($(color "${3}"))"
    echo "Column 2 font color = ${column2_font_color:-default} ($(color "${4}"))"
}

color() {
    local index=$1

    case "$index" in
        1) echo white ;;
        2) echo "red" ;;
        3) echo green ;;
        4) echo blue ;;
        5) echo purple ;;
        6) echo black ;;
    esac
}
