#!/bin/bash

# Скрипт run.sh служит для упрощенного запуска повседневных команд, которые запускаются при работе с проектом
# Команды делятся на 2 группы:
#   1. Базовые команды 
#   2. Пользовательские команды
# Пользовательские команды берутся из файла run_commands.txt, который находится в корне проекта
# Формат пользовательской команды:
# --begin
# Псевдоним
# Команда
# Описание что делает данная команда
# --end
# Все пользовательские команды должны быть заключены в блоки --begin --end
# Все пользовательские команды запускаются относительно корня проекта


# Определение цвета
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' 

#
PATH_TO_BACKEND_DJANGO="/services/drf"
PATH_TO_BACKEND_FASTAPI="/services/fastapi"
PATH_TO_BACKEND_DOCS="/services/drf/apps/sphinx_docs/docs"


# Получение параметров командной строки
USER_INPUT="$@"
USER_COMMAND="$1"
USER_PARAMS="$2"

# Определение абсолютного пути к каталогу скрипта
SCRIPT_DIR=$(cd -P "$(dirname -- "$0")" && pwd -P)

# Извлекаем только имя папки из полного пути
FOLDER_NAME=$(basename "$SCRIPT_DIR")

# Файл с пользовательскими командами
USER_COMMAND_FILE=$SCRIPT_DIR"/files/commands/run_commands.txt"

#
source $SCRIPT_DIR"/files/commands/command_sphinx_docs.sh"
source $SCRIPT_DIR"/files/commands/command_ruff.sh"

# Вывод текста обычным, белым, цветом
print_text_white() {
    echo -en "$1"
}

# Вывод текста красным цветом  \u2718 
print_text_red() {
    echo -en "${RED}$1${NC}"
}

# Вывод текста зеленым цветом \u2714 
print_text_green() { 
    echo -en "${GREEN}$1${NC}" 
}

# Вывод текста синим цветом
print_text_blue() {
    echo -en "${BLUE}$1${NC}"
}

# Вывод текста желтым цветом
print_text_yellow() {
    echo -en "${YELLOW}$1${NC}"
}

# Вывод линии на всю ширину экрана
line() {
    cols=$(tput cols)
    for ((i=1; i<=cols; i++)); do echo -en "\u2500"; done
    echo -e ""
}

# Вывод заголовка
print_header() {
    line
    print_text_yellow "Справка по доступным командам \u00ABrun.sh\u00BB\n"
    print_text_white "./run.sh [command]\n"
    line 
    print_text_yellow "Основные команды\n"
    line
    print_text_green "1|mdrf [params]"
    print_text_white " \u2501 Запустить manage.py в backend/drf контейнере \n"   
    print_text_white "  В качестве [params] можно использовать, припример, makemigrations, migrate, createsuperuser и т.д. \n" 
    print_text_white "  Полный перечень параметров можно получить запустив команду без параметров \n" 
    print_text_green "2|tdrf [params]"
    print_text_white " \u2501 Запустить pytest в backend/drf контейнере\n"      
    print_text_green "3|sdrf"
    print_text_white " \u2501 Запустить /bin/bash в backend/drf контейнере для ручного выполнения команд\n"  
    print_text_green "4|sfastapi"
    print_text_white " \u2501 Запустить /bin/bash в backend/fastapi контейнере для ручного выполнения команд\n" 
    print_text_green "5|sddrf"
    print_text_white " \u2501 Сгенерировать Sphinx документацию\n"       
    print_text_green "6|rcdrf [params]"
    print_text_white " \u2501 Запустить ruff check для backend/drf\n"     
    print_text_green "7|rfdrf [params]"
    print_text_white " \u2501 Запустить ruff format для backend/drf\n"       
    print_text_green "8|rcfastapi [params]"
    print_text_white " \u2501 Запустить ruff check для backend/fastapi\n"     
    print_text_green "9|rffastapi [params]"
    print_text_white " \u2501 Запустить ruff format для backend/fastapi\n"                  
    line  
}

# Основная функция которая читает файл с пользовательскими командами
read_file() {
    in_block=false
    line_counter=0  
    
    print_text_yellow "Команды из файла \u00AB$USER_COMMAND_FILE\u00BB\n"; line

    while IFS= read -r line; do
        if [[ "$line" == "--begin" ]]; then
            in_block=true
            line_counter=0 
            continue
        fi

        if [[ "$line" == "--end" ]]; then
            in_block=false
            line_counter=0  
            continue
        fi

        if $in_block; then
            ((line_counter++)) 

            if [[ $line_counter -eq 1 ]]; then
                print_text_blue "$line"
            elif [[ $line_counter -eq 2 ]]; then
                print_text_white " \u2501 $line \n"            
            elif [[ $line_counter -ge 3 ]]; then
                print_text_white "  $line \n"
            fi
        fi
    done < "$USER_COMMAND_FILE"    
    line
}

# Запуск пользовательской команды
start_user_command() {
    in_block=false
    line_counter=0  
    is_start=false
    
    while IFS= read -r line; do
        if [[ "$line" == "--begin" ]]; then
            in_block=true
            line_counter=0 
            continue
        fi

        if [[ "$line" == "--end" ]]; then
            in_block=false
            line_counter=0  
            continue
        fi

        if $in_block; then
            ((line_counter++)) 

            if [[ $line_counter -eq 1 ]]; then
                if [[ "$line" == "$USER_COMMAND" ]]; then
                    is_start=true
                else
                    is_start=false
                fi
            elif [[ $line_counter -eq 2 ]]; then
                if [[ $is_start == true ]]; then
                    start_command $line
                fi            
            fi
        fi
    done < "$USER_COMMAND_FILE"    
}

# Проверка статуса выполнения команды
check_command_run_status() {
    command_run_status="$1"
    command_run="$2"

    output_text=$USER_INPUT
    if [[ -n "$command_run" ]]; then
        output_text+=" ($command_run)"
    fi


    if [ $command_run_status -ne 0 ]; then
        line; print_text_red "\u2718 Ошибка выполнения комманды \u00AB$output_text\u00BB\n"; line
        exit $command_run_status
    fi
    line; print_text_green "\u2714 Команда \u00AB$output_text\u00BB выполнилась успешно\n"; line

    # exit 0    
} 
# Непосредственный запуск команды а также проверка результата выполнения
start_command() {
    command="$@"
    cd $SCRIPT_DIR
    eval "$command"

    check_command_run_status $?
    
    exit 0
}

# manage
command_manage() {
    docker exec -it ${FOLDER_NAME}-service.drf-1 uv run python3 manage.py $USER_PARAMS
    check_command_run_status $? "Выполнение команды python3 manage.py $USER_PARAMS"
}

# docker shell drf
command_shell_drf() {
    docker exec -it ${FOLDER_NAME}-service.drf-1 /bin/bash
    check_command_run_status $?
}

# docker shell fastapi
command_shell_fastapi() {
    docker exec -it ${FOLDER_NAME}-service.fastapi-1 /bin/bash
    check_command_run_status $?
}

# pytest
command_pytest() {
    docker exec -it ${FOLDER_NAME}-service.drf-1 uv run pytest "$USER_PARAMS"
    check_command_run_status $? "$USER_INPUT"
}

# Запуск предустановленных команд
start_exist_command() {

    case $USER_COMMAND in
        1|mdrf)
            command_manage
            ;;    
        2|tdrf)
            command_pytest
            ;;   
        3|sddrf)
            command_drf_gendoc
            ;;  
        4|sfastapi)
            command_shell_fastapi
            ;;              
        5|sdrf)
            command_shell_drf
            ;;
        6|rcdrf)
            command_ruff_check_drf
            ;;       
        7|rfdrf)
            command_ruff_format_drf
            ;;    
        8|rcfastapi)
            command_ruff_check_fastapi
            ;;       
        9|rffastapi)
            command_ruff_format_fastapi
            ;;                             
        *)
            line; print_text_red "\u2718 Нет такой комманды \u00AB$USER_COMMAND\u00BB\n"
            print_text_white "Запустите \u00ABrun.sh\u00BB без параметров что-бы посмотреть список доступных команд\n"
            line
            ;;        
    esac    
}

# Основная функция которая запуская все остальные
main() {
    if [[ -z "$USER_COMMAND" ]]; then
        print_header
        read_file 
    else
        start_user_command
        start_exist_command
    fi    
}

# Запуск основной функции
main 