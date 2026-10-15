#!/usr/bin/env bash

collect_data() {
    local path="$1"

    # Общее число папок, включая вложенные
    total_folders=$(find "$path" -type d -printf '.' 2>/dev/null | wc -c)
    # Общее число файлов
    total_files=$(find "$path" -type f -printf '.' 2>/dev/null | wc -c)
    # Число конфигурационных файлов (с расширением .conf)
    conf_files=$(find "$path" -type f -name "*.conf" -printf '.' 2>/dev/null | wc -c)
    # Число текстовых файлов (с расширением .txt)
    txt_files=$(find "$path" -type f -name "*.txt" -printf '.' 2>/dev/null | wc -c)
    # Число исполняемых файлов
    exe_files=$(find "$path" -type f -executable -printf '.' 2>/dev/null | wc -c)
    # Число логов (файлов с расширением .log)
    log_files=$(find "$path" -type f -name "*.log" -printf '.' 2>/dev/null | wc -c)
    # Число архивных файлов
    archive_files=$(find "$path" -type f \( \
        -iname '*.zip' -o -iname '*.rar' -o -iname '*.7z' -o \
        -iname '*.tar' -o -iname '*.gz' -o -iname '*.bz2' -o \
        -iname '*.xz' -o -iname '*.tgz' -o -iname '*.tbz' -o \
        -iname '*.tbz2' -o -iname '*.txz' \
        \) -printf '.' 2>/dev/null | wc -c)
    # Число символических ссылок
    link_files=$(find "$path" -type l -printf '.' 2>/dev/null | wc -c)
}
