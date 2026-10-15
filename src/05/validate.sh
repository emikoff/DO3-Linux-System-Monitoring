#!/usr/bin/env bash

validate_path() {
    local input_path="$1"

    if [[ "$input_path" != */ ]]; then
        echo "Ошибка: параметр должен заканчиваться знаком '/', например /var/log/."
        exit 1
    fi

    if [ ! -d "$input_path" ]; then
        echo "Ошибка: такой директории не существует."
        exit 1
    fi
}
