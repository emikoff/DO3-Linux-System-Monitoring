#!/usr/bin/env bash

# Выводит общее число папок, включая вложенные
print_total_folders() {
    local total_folders="$1"
    echo "Total number of folders (including all nested ones) = $total_folders"
}

# Выводит список папок максимального размера в порядке убывания (путь и размер)
print_top_folders() {
    local path="$1"
    local num="${2:-5}"
    local record size folder
    local i=1

    echo "TOP $num folders of maximum size arranged in descending order (path and size):"

    while IFS= read -r -d '' record; do
        size=${record%%$'\t'*}
        folder=${record#*$'\t'}
        printf '%d - %s/, %s\n' "$i" "${folder%/}" "$(human "$size")"
        ((i++))
    done < <(
        while IFS= read -r -d '' folder; do
            size=$(du -s -B1 -- "$folder" 2>/dev/null | awk 'NR == 1 {print $1}')
            [[ -n "$size" ]] && printf '%s\t%s\0' "$size" "$folder"
        done < <(find "$path" -mindepth 1 -type d -print0 2>/dev/null) \
        | sort -z -nr \
        | head -z -n "$num"
    )

    echo "etc up to $num"
}

# Выводит общее число файлов
print_total_files() {
    local total_files="$1"

    echo "Total number of files = $total_files"
}

# Выводит количество файлов по категориям
print_data_files() {
    local conf_files="$1"
    local txt_files="$2"
    local exe_files="$3"
    local log_files="$4"
    local archive_files="$5"
    local link_files="$6"

    echo "Number of:"
    echo "Configuration files (with the .conf extension) = $conf_files"
    echo "Text files = $txt_files"
    echo "Executable files = $exe_files"
    echo "Log files (with the extension .log) = $log_files"
    echo "Archive files = $archive_files"
    echo "Symbolic links = $link_files"
}

# Преобразует размер в человекочитаемый вид
human() {
    local size="$1"
    local unit='B'

    if [ "$size" -ge 1024 ]; then
        size="$((size/1024))"
        unit='KB'
    fi
    if [ "$size" -ge 1024 ]; then
        size="$((size/1024))"
        unit='MB'
    fi
    if [ "$size" -ge 1024 ]; then
        size="$((size/1024))"
        unit='GB'
    fi
    if [ "$size" -ge 1024 ]; then
        size="$((size/1024))"
        unit='TB'
    fi

    echo "$size $unit"
}

# Выводит список самых крупных файлов в порядке убывания (путь, размер и тип)
print_top_files() {
    local path="$1"
    local num="${2:-10}"
    local i=1
    local record file size ext file_name

    echo "TOP $num files of maximum size arranged in descending order (path, size and type):"

    while IFS= read -r -d '' record; do
        size=${record%%$'\t'*}
        file=${record#*$'\t'}
        file_name=${file##*/}
        
        if [[ "$file_name" == *.* ]]; then
            ext="${file_name##*.}"
        else
            ext="unknown"
        fi
  
        printf "%s - %s, %s, %s\n" "$i" "$file" "$(human "$size")" "$ext"
        ((i++))
    done < <(
        find "$path" -type f -printf '%s\t%p\0' 2>/dev/null \
        | sort -z -nr \
        | head -z -n "$num"
    )

    echo "etc up to $num"
}

# Выводит топ исполняемых файлов по размеру (путь, размер и MD5-хеш)
print_top_exe_files() {
    local path="$1"
    local num="${2:-10}"
    local i=1
    local record file size hash

    echo "TOP $num executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"

    while IFS= read -r -d '' record; do
        size=${record%%$'\t'*}
        file=${record#*$'\t'}

        hash=$(md5sum "$file" 2>/dev/null | awk '{print $1}')

        printf "%s - %s, %s, %s\n" "$i" "$file" "$(human "$size")" "$hash"
        ((i++))
    done < <(
        find "$path" -type f -executable -printf '%s\t%p\0' 2>/dev/null \
        | sort -z -nr \
        | head -z -n "$num"
    )

    echo "etc up to $num"
}

# расчет выполнения время скрипта
print_execution_time() {
    local start_time="$1"
    local end_time="$2"

    local execution_time
    execution_time=$(awk -v start="$start_time" -v end="$end_time" \
        'BEGIN {printf "%.2f", end - start}')

    echo "Script execution time (in seconds) = $execution_time"
}
