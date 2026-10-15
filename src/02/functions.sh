#!/usr/bin/env bash

# Формирование массива строк отчета
# Перебирает список имен переменных и создает массив строк вида "ИМЯ = ЗНАЧЕНИЕ"
build_report() {
    data=()
    for key in "${params[@]}"; do
        # ${!key} — косвенная ссылка: позволяет получить значение переменной,
        # имя которой хранится в переменной key.
        local val=${!key}
        data+=( "$key = $val" )
    done
}

# Вывод строк отчета в терминал
display_report() {
    for line in "${data[@]}"; do
            echo "$line"
    done
}

# Создает файл отчета с именем на основе текущей даты и времени
write_report() {
    local file_name
    # Формат имени: DD_MM_YY_HH_MM_SS.status
    file_name=$(date +"%d_%m_%y_%H_%M_%S").status
    
    # Записывает каждую строку массива в файл с новой строки
    printf "%s\n" "${data[@]}" > "$file_name"
    echo "Данные успешно сохранены в файл: $file_name"
}

# Запрашивает у пользователя подтверждение на сохранение отчета в файл
ask_to_save() {
    echo "-----------------------------------"
    read -r -p "Желаете записать эти данные в файл? (Y/N): " answer

    if [[ "$answer" == "Y" || "$answer" == "y" ]]; then
        write_report
    else
        echo "Запись отменена пользователем."
    fi
}
