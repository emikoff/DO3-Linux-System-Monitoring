#!/bin/bash

check='^[0-9]+$'

if [ $# -ne 1 ]; then
    echo "Ошибка: недопустимое количество аргументов"
    exit 1
fi

if [[ $1 =~ $check ]]; then
    echo "Ошибка: неправильный ввод"
    exit 1
fi

echo "$1"