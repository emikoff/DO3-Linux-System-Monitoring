#!/usr/bin/env bash

set -u
set -o pipefail

PROJECT_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
passed=0
failed=0
test_dir=$(mktemp -d)

cleanup() {
    rm -rf -- "$test_dir"
}
trap cleanup EXIT

pass() {
    printf 'PASS: %s\n' "$1"
    ((passed++))
}

fail() {
    printf 'FAIL: %s\n' "$1" >&2
    ((failed++))
}

expect_status() {
    local name="$1"
    local expected_status="$2"
    shift 2

    local status
    if "$@" >/dev/null 2>&1; then
        status=0
    else
        status=$?
    fi

    if [[ "$status" -eq "$expected_status" ]]; then
        pass "$name"
    else
        fail "$name (ожидался код $expected_status, получен $status)"
    fi
}

expect_output() {
    local name="$1"
    local expected_text="$2"
    shift 2

    local output
    local status
    if output=$("$@" 2>&1); then
        status=0
    else
        status=$?
    fi

    if [[ "$status" -eq 0 && "$output" == *"$expected_text"* ]]; then
        pass "$name"
    else
        fail "$name (код $status, не найдено: $expected_text)"
    fi
}

expect_failure_output() {
    local name="$1"
    local expected_text="$2"
    shift 2

    local output
    local status
    if output=$("$@" 2>&1); then
        status=0
    else
        status=$?
    fi

    if [[ "$status" -ne 0 && "$output" == *"$expected_text"* ]]; then
        pass "$name"
    else
        fail "$name (код $status, не найдено: $expected_text)"
    fi
}

part1="$PROJECT_ROOT/src/01/main.sh"
part2="$PROJECT_ROOT/src/02/main.sh"
part3="$PROJECT_ROOT/src/03/main.sh"
part4="$PROJECT_ROOT/src/04/main.sh"
part5="$PROJECT_ROOT/src/05/main.sh"

# shellcheck source=src/04/functions.sh
source "$PROJECT_ROOT/src/04/functions.sh"

expect_output "Part 1 принимает текст" "monitor" bash "$part1" monitor
expect_failure_output "Part 1 отклоняет цифры" "неправильный ввод" bash "$part1" 123
expect_output "Part 1 сохраняет исходное поведение для -7" "-7" bash "$part1" -7
expect_failure_output "Part 1 требует один аргумент" "количество аргументов" bash "$part1"

expect_failure_output "Part 2 не принимает аргументы" "не принимает параметры" \
    bash "$part2" unexpected
expect_failure_output "Part 3 требует четыре аргумента" "четырьмя аргументами" \
    bash "$part3" 1 2 3
expect_failure_output "Part 3 отклоняет одинаковые цвета" "цвета текста и фона" \
    bash "$part3" 1 1 2 3
expect_failure_output "Part 4 не принимает аргументы" "не принимает параметры" \
    bash "$part4" unexpected

expect_status "Part 4 принимает корректную цветовую схему" 0 \
    check_param 1 6 2 4
expect_status "Part 4 отклоняет нечисловой цвет" 1 \
    check_param red 6 2 4

fixture="$test_dir/fixture"
mkdir -p "$fixture/dir with space"
printf 'setting=1\n' > "$fixture/app.conf"
printf 'text\n' > "$fixture/dir with space/example file.txt"
printf 'log\n' > "$fixture/app.log"
printf 'archive\n' > "$fixture/sample.tar.gz"
printf '#!/usr/bin/env bash\necho ok\n' > "$fixture/tool.sh"
chmod +x "$fixture/tool.sh"
ln -s "$fixture/app.conf" "$fixture/config link"

expect_failure_output "Part 5 требует завершающий слеш" "заканчиваться знаком '/'" \
    bash "$part5" "$fixture"
expect_failure_output "Part 5 отклоняет отсутствующий каталог" "не существует" \
    bash "$part5" "$test_dir/missing/"
expect_output "Part 5 считает файлы" "Total number of files = 5" \
    bash "$part5" "$fixture/"
expect_output "Part 5 распознаёт архив" "Archive files = 1" \
    bash "$part5" "$fixture/"
expect_output "Part 5 распознаёт символическую ссылку" "Symbolic links = 1" \
    bash "$part5" "$fixture/"
expect_output "Part 5 обрабатывает пробелы в пути" "dir with space/example file.txt" \
    bash "$part5" "$fixture/"

printf '\nРезультат: %d успешно, %d ошибок\n' "$passed" "$failed"
[[ "$failed" -eq 0 ]]
