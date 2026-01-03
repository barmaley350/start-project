#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

BASE_DIR=$(pwd)
BACKEND_DIR_DRF="${BASE_DIR}/services/drf"
BACKEND_DIR_FASTAPI="${BASE_DIR}/services/fastapi"
FRONTEND_DIR="${BASE_DIR}/services/nuxtjs"

PROJECT_NAME=$(basename "$PWD")

NGINX_PORT=1338
ADMINER_PORT=8099

# ------------------------------------------------------------------------------------
# Названия для шагов
# ------------------------------------------------------------------------------------
service_print_steps_text() {
    case $1 in
        step1)
            echo -e "Проверка установленных зависимостей docker, nodejs, npm, pipenv"
            ;;
        step2)
            echo -e "Настройка backend/drf (pipenv sync --dev)"
            ;;     
        step3)
            echo -e "Настройка backend/fastapi (pipenv sync --dev)"
            ;;    
        step4)
            echo -e "Настройка frontend/nuxtjs (npm install)"
            ;;  
        step5)
            echo -e "Настройка переменных окружения для backend/frontend/docker"
            ;;   
        step51)
            echo -e "Настройка переменных окружения для backend/drf"
            ;;    
        step52)
            echo -e "Настройка переменных окружения для backend/fastapi"
            ;;   
        step53)
            echo -e "Настройка переменных окружения для frontend/nuxtjs"
            ;;   
        step54)
            echo -e "Настройка переменных окружения для docker"
            ;;                                             
        step6)
            echo -e "Все готово для старта. Что дальше?"
            ;;                                                   
        *)
            echo -e "Шаг не определен"
            ;;
    esac
}

print_text_success() {
    echo -e "${GREEN} \u2714 $1${NC}"
}

print_text_error() {
    echo -e "${RED} \u2718 $1${NC}"
}

print_text_info() {
    echo -e "${YELLOW}$1${NC}"
}

print_text_info2() {
    echo -e "${BLUE}$1${NC}"
}

line_output() {
    cols=$(tput cols)
    for ((i=1; i<=cols; i++)); do echo -en "\u2500"; done
    echo -e ""
}

line_output2() {
    cols=$(tput cols)
    word_begin=$1
    word_end=$2
    cols=$cols-${#word_begin}-${#word_end}

    echo -en $word_begin
    for ((i=1; i<=cols; i++)); do echo -en "."; done
    echo -en $word_end
    echo -e ""
}

print_text_block() {
    case $1 in
        success)
            line_output
            print_text_success "$2"
            line_output
            ;;
        error)
            line_output
            print_text_error "$2"
            line_output
            ;;
        info)
            line_output
            print_text_info "$2"
            line_output
            ;;
        info2)
            line_output
            print_text_info2 "$2"
            line_output
            ;;
        empty)
            line_output
            echo "$2"
            line_output
            ;;
        *)
            line_output
            print_text_success "$2"
            line_output
            ;;
    esac
}

#clear_screen ---------------------
clear_screen() {
    clear
}

# ------------------------------------------------------------------------------------
# header
# ------------------------------------------------------------------------------------
print_header() {
    clear_screen
    print_text_block empty "$(print_text_success "Настройка проекта \u00AB${PROJECT_NAME}\u00BB")"
    echo -e "Данный скрипт поможет произвести начальную настройку проекта."
    echo -e "Если вы не планируете вносить какие-либо изменения в настройки по умолчанию,"
    echo -e "то можете просто нажать Enter на каждом пункте меню либо запусть скрипт с ключом -y"
    echo -e "Вы также можете использовать s для того чтобы пропусти какой-либо пункт настройки."
    echo -e ""
    echo -e "$(print_text_info 'Шаг #1') - $(service_print_steps_text step1)"
    echo -e "$(print_text_info 'Шаг #2') - $(service_print_steps_text step2)"       
    echo -e "$(print_text_info 'Шаг #3') - $(service_print_steps_text step3)"    
    echo -e "$(print_text_info 'Шаг #4') - $(service_print_steps_text step4)"
    echo -e "$(print_text_info 'Шаг #5') - $(service_print_steps_text step5)"
    echo -e "$(print_text_info 'Шаг #6') - $(service_print_steps_text step6)"

    confirm_to_continue "Выполнить Шаг #1 - $(service_print_steps_text step1)?"
    
}

# ------------------------------------------------------------------------------------
# confirm
# ------------------------------------------------------------------------------------
confirm_to_continue() {
    prompt="${1:-"Продолжить выполнение?"}"
    echo ""
    echo "${prompt}"
    read -rp $"(Enter to continue / any key to exit): " confirm
    [[ -z "$confirm" || "$confirm" =~ ^[Yy]$ ]] || { print_text_info "Отмена."; exit 0; }
}

# ------------------------------------------------------------------------------------
# Проверка установленных зависимостей в системе
# ------------------------------------------------------------------------------------
step1_check_system_requirements() {
    clear_screen
    print_text_block info "Шаг #1 - $(service_print_steps_text step1)"

    if ! command -v docker &> /dev/null; then
        line_output2 "Docker" "$(print_text_error "Error")"
        print_text_error "docker не установлен. Установите docker https://docs.docker.com/desktop/setup/install/linux/ubuntu/"
        echo ""
        exit 1
    fi
    line_output2 "Docker" "$(print_text_success "OK")"

    if ! command -v node &> /dev/null; then
        line_output2 "Node.js" "$(print_text_error "Error")"
        print_text_error "Node.js не установлен. Установите nodejs https://nodejs.org/en/download"
        echo ""
        exit 1
    fi
    line_output2 "Node.js" "$(print_text_success "OK")"

    if ! command -v npm &> /dev/null; then
        line_output2 "npm" "$(print_text_error "Error")"
        print_text_error "npm не установлен. Установите npm https://nodejs.org/en/download"
        echo ""
        exit 1
    fi
    line_output2 "npm" "$(print_text_success "OK")"

    if ! command -v pipenv &> /dev/null; then
        line_output2 "pipenv" "$(print_text_error "Error")"
        print_text_error "pipenv не установлен. Установите pipenv https://pipenv.pypa.io/en/latest/installation.html"
        echo ""
        exit 1
    fi
    line_output2 "pipenv" "$(print_text_success "OK")"

    print_text_block success "Шаг #1 успешно выполнен"
    confirm_to_continue "Выполнить Шаг #2 - $(service_print_steps_text step2)?"
}

# ------------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------------
confirm_creation_backend_drf() {
    clear_screen
    # print_text_block info "Шаг 2 - Сейчас мы выполним настройку \u00ABbackend/drf\u00BB"
    print_text_block info "Шаг 2 - $(service_print_steps_text step2)"
    echo "Для этого мы выполним следующие действия:"
    echo -e "\u2014 Перейдем в каталог $(print_text_info2 ${BACKEND_DIR_DRF})"
    echo -e "\u2014 Выполним команду $(print_text_info2 'pipenv sync --dev')"

    confirm_to_continue
}

# ------------------------------------------------------------------------------------
#  
# ------------------------------------------------------------------------------------
step2_install_backend_drf() {
    cd $BACKEND_DIR_DRF

    clear_screen
    confirm_creation_backend_drf

    if pipenv sync --dev; then
        print_text_block success "Шаг #2 успешно выполнен"
        confirm_to_continue "Выполнить Шаг #3 - $(service_print_steps_text step3)?"        
        return 0
    else
        print_text_block error "Возникли ошибки при выполении pipenv sync --dev"
        return 1
    fi
}

# ------------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------------
confirm_creation_backend_fastapi() {
    clear_screen
    # print_text_block info "Шаг 3 - Сейчас мы выполним настройку \u00ABbackend/fastapi\u00BB"
    print_text_block info "Шаг 3 - $(service_print_steps_text step3)"
    echo "Для этого мы выполним следующие действия:"
    echo -e "\u2014 Перейдем в каталог $(print_text_info2 ${BACKEND_DIR_FASTAPI})"
    echo -e "\u2014 Выполним команду $(print_text_info2 'pipenv sync --dev')"

    confirm_to_continue
}

step3_install_backend_fastapi() {
    cd $BACKEND_DIR_FASTAPI

    clear_screen
    confirm_creation_backend_fastapi

    if pipenv sync --dev; then
        print_text_block success "Шаг #3 успешно выполнен"
        confirm_to_continue "Выполнить Шаг #4 - $(service_print_steps_text step4)?"           
        return 0
    else
        print_text_block error "Возникли ошибки при выполении pipenv sync --dev"
        return 1
    fi
}

# ------------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------------
confirm_creation_frontend() {
    clear_screen
    # print_text_block info "Шаг 4 - Сейчас мы выполним настройку \u00ABfrontend/nuxtjs\u00BB"
    print_text_block info "Шаг 4 - $(service_print_steps_text step4)"
    echo "Для этого мы выполним следующие действия:"
    echo -e "\u2014 Перейдем в каталог $(print_text_info2 ${FRONTEND_DIR})"
    echo -e "\u2014 Выполним команду $(print_text_info2 'npm install')"
    
    confirm_to_continue 
}

# ------------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------------
step4_install_frontend() {
    cd $FRONTEND_DIR

    clear_screen
    confirm_creation_frontend

    if npm install; then
        print_text_block success "Шаг #4 успешно выполнен"
        confirm_to_continue "Выполнить Шаг #5 - $(service_print_steps_text step5)?"           
        return 0
    else
        print_text_block error "Ошибка при запуске npm install"
        return 1
    fi
}

# ------------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------------
confirm_creation_env() {
    clear_screen
    # print_text_block info "Шаг 5 - Настройка переменных окружения"
    print_text_block info "Шаг 5 - $(service_print_steps_text step5)"
    # echo "Для (frontend) мы выполним следующие действия:"
    echo -e "$(service_print_steps_text step53)"
    echo -e "\u2014 Перейдем в каталог  $(print_text_info2 ${FRONTEND_DIR})"
    echo -e "\u2014 Выполним команду  $(print_text_info2 'cp .env.example .env')"

    echo ""
    # echo "Для (backend/drf) мы выполним следующие действия:"
    echo -e "$(service_print_steps_text step51)"
    echo -e "\u2014 Перейдем в каталог  $(print_text_info2 ${BACKEND_DIR_DRF})"
    echo -e "\u2014 Выполним команду $(print_text_info2 'cp .env.example .env')"
    echo -e "\u2014 Настроим $(print_text_info2 'SECRET_KEY') и $(print_text_info2 'POSTGRES_PASSWORD')"
    echo -e "Вы всегда сможете изменить эти параметры в файле $(print_text_info2 'services/drf/.env')"

    echo ""
    # echo "Для (backend/fastapi) мы выполним следующие действия:"
    echo -e "$(service_print_steps_text step52)"
    echo -e "\u2014 Перейдем в каталог  $(print_text_info2 ${BACKEND_DIR_FASTAPI})"
    echo -e "\u2014 Выполним команду $(print_text_info2 'cp .env.example .env')"
    echo -e "\u2014 Настроим $(print_text_info2 'POSTGRES_PASSWORD')"
    echo -e "По умолчанию настройки работы с db копируются из $(print_text_info2 'services/drf/.env')"
    echo -e "Вы всегда сможете изменить эти параметры в файле $(print_text_info2 'services/fastapi/.env')"

    echo ""
    # echo "Для (docker) мы выполним следующие действия:"
    echo -e "$(service_print_steps_text step54)"
    echo -e "\u2014 Перейдем в каталог $(print_text_info2 ${BASE_DIR})"
    echo -e "\u2014 Выполним команду $(print_text_info2 'cp .env.example .env')"
    echo -e "\u2014 Настроим $(print_text_info2 'NGINX_PORT') (по умолчанию ${NGINX_PORT}) и $(print_text_info2 'ADMINER_PORT') (по умолчанию ${ADMINER_PORT})"
    echo -e "Вы всегда сможете изменить эти параметры в файле $(print_text_info2 '.env') в корне проекта."

    confirm_to_continue
}

# ------------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------------
check_if_env_exist_or_not_text() {
    case $1 in
        reuse)
            echo -e "Файл $(print_text_info2 ${2}/.env) существует."
            echo -e "Настройки по умолчанию копируются из этого файла."
            ;;    
        exist)
            echo -e "Файл $(print_text_info2 ${2}/.env) существует."
            echo -e "Настройки по умолчанию берутся из этого файла."
            echo -e "Если какие-то настройки уже существуют в этом файле, то они сохранят свои значения."
            ;;
        copy)
            echo -e "Файл $(print_text_info2 ${2}/.env) не существует."
            echo -e "Файл $(print_text_info2 '.env.example') скопирован в $(print_text_info2 '.env')."
            ;;
        error)
            print_text_error "Файл .env.example не существует."
            echo -e "Каталог - ${2}."
            echo -e "Проверьте наличие файла $(print_text_info2 '.env.example') в указанном каталоге."
            echo -e ""
            ;;
    esac
}

# ------------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------------
create_env_frontend_nuxtjs() {
    clear_screen
    print_text_block info "$(service_print_steps_text step53)"

    cd $FRONTEND_DIR

    if [ -e ".env.example" ]; then
        if [ -e ".env" ]; then
            . .env
            check_if_env_exist_or_not_text exist $FRONTEND_DIR
        else
            cp .env.example .env
            check_if_env_exist_or_not_text copy $FRONTEND_DIR
        fi
    else
        check_if_env_exist_or_not_text error $FRONTEND_DIR
        return 1
    fi

    # print_text_block success "Настройка параметров окружения для frontend завершена"
    print_text_block success "$(service_print_steps_text step53) завершена"
    # line_output2 "$(service_print_steps_text step53)" "$(print_text_success "Ok")"
    # confirm_to_continue
    confirm_to_continue "Далее - $(service_print_steps_text step51)"
}

# ------------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------------
create_env_backend_drf() {
    clear_screen
    # print_text_block info "Настройка параметров окружения для backend"
    print_text_block info "$(service_print_steps_text step51)"

    cd $BACKEND_DIR_DRF

    if [ -e ".env.example" ]; then
        if [ -e ".env" ]; then
            . .env

            check_if_env_exist_or_not_text exist $BACKEND_DIR_DRF
        else
            cp .env.example .env
            check_if_env_exist_or_not_text copy $BACKEND_DIR_DRF
            local SECRET_KEY=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 16)
            local POSTGRES_PASSWORD=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 16)
        fi
    else
        check_if_env_exist_or_not_text error $BACKEND_DIR_DRF
        return 1
    fi

    echo -e ""
    read -rp $' \u00BB Укажите SECRET_KEY (по умолчанию: '"$SECRET_KEY"'): ' secret_key_value

    SECRET_KEY="${secret_key_value:-$SECRET_KEY}"

    read -rp $' \u00BB Укажите POSTGRES_PASSWORD (по умолчанию: '"$POSTGRES_PASSWORD"'): ' postgres_password_value
    POSTGRES_PASSWORD="${postgres_password_value:-$POSTGRES_PASSWORD}"

    sed -i "s|^SECRET_KEY=.*|SECRET_KEY=\"$SECRET_KEY\"|" .env
    sed -i "s|^POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=\"$POSTGRES_PASSWORD\"|" .env

    # print_text_block success "Настройка параметров окружения для backend завершена"
    print_text_block success "$(service_print_steps_text step51) завершена"
    confirm_to_continue "Далее - $(service_print_steps_text step52)"
}

# ------------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------------
create_env_backend_fastapi() {
    clear_screen
    # print_text_block info "Настройка параметров окружения для backend"
    print_text_block info "$(service_print_steps_text step52)"

    cd $BACKEND_DIR_DRF
    . .env
    check_if_env_exist_or_not_text reuse $BACKEND_DIR_DRF

    cd $BACKEND_DIR_FASTAPI

    if [ -e ".env.example" ]; then
        if [ -e ".env" ]; then
            check_if_env_exist_or_not_text exist $BACKEND_DIR_FASTAPI
        else
            cp .env.example .env
            check_if_env_exist_or_not_text copy $BACKEND_DIR_FASTAPI
        fi
    else
        check_if_env_exist_or_not_text error $BACKEND_DIR_FASTAPI
        return 1
    fi

    sed -i "s|^POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=\"$POSTGRES_PASSWORD\"|" .env

    # print_text_block success "Настройка параметров окружения для backend завершена"
    print_text_block success "$(service_print_steps_text step52) завершена"
    confirm_to_continue "Далее - $(service_print_steps_text step54)"
}

# ------------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------------
create_env_docker() {
    clear_screen
    # print_text_block info "Настройка параметров окружения для docker"
    print_text_block info "$(service_print_steps_text step54)"

    cd $BASE_DIR

    if [ -e ".env.example" ]; then
        if [ -e ".env" ]; then
            . .env

            check_if_env_exist_or_not_text exist $BASE_DIR
        else
            cp .env.example .env
            check_if_env_exist_or_not_text copy $BASE_DIR
            
            local DB_VOLUME_NAME="$PROJECT_NAME-db-volume"
            local STATIC_VOLUME_NAME="$PROJECT_NAME-static-volume"
        fi
    else
        check_if_env_exist_or_not_text error $BASE_DIR
        return 1
    fi

    echo -e ""
    read -rp $' \u00BB Укажите NGINX_PORT (по умолчанию: '"$NGINX_PORT"'): ' nginx_port_value
    NGINX_PORT="${nginx_port_value:-$NGINX_PORT}"

    read -rp $' \u00BB Укажите ADMINER_PORT (по умолчанию: '"$ADMINER_PORT"'): ' adminer_port_value
    ADMINER_PORT="${adminer_port_value:-$ADMINER_PORT}"

    sed -i "s|^NGINX_PORT=.*|NGINX_PORT=$NGINX_PORT|" .env
    sed -i "s|^ADMINER_PORT=.*|ADMINER_PORT=$ADMINER_PORT|" .env
    sed -i "s|^DB_VOLUME_NAME=.*|DB_VOLUME_NAME=\"$DB_VOLUME_NAME\"|" .env
    sed -i "s|^STATIC_VOLUME_NAME=.*|STATIC_VOLUME_NAME=\"$STATIC_VOLUME_NAME\"|" .env

    # sed -i "s|^PROJECT_BASE_DIR=.*|PROJECT_BASE_DIR=\"$BASE_DIR\"|" .env
    # sed -i "s|^PROJECT_NAME=.*|PROJECT_NAME=\"$PROJECT_NAME\"|" .env

    # print_text_block success "Настройка параметров окружения для docker завершена"
    print_text_block success "$(service_print_steps_text step54) завершена"
    confirm_to_continue "Далее - $(service_print_steps_text step6)"
}

# ------------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------------
step5_create_envs() {
    confirm_creation_env
    create_env_frontend_nuxtjs
    create_env_backend_drf
    create_env_backend_fastapi
    create_env_docker
}

# ------------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------------
step6_next_steps() {
    clear_screen
    print_text_block empty "$(print_text_success "Настройка проекта \u00AB${PROJECT_NAME}\u00BB завершена! Что дальше?")"

    echo -e "$(print_text_info 'Запустите docker')"
    echo -e "Перейдите в $(print_text_info2 ${BASE_DIR})"
    echo -e "Выполните комманду $(print_text_info2 'docker compose up --build')"
    echo -e "Убедитесь что все запустилось и сайт доступен по адресу $(print_text_info2 http://localhost:${NGINX_PORT})"
    echo -e ""

    # echo -e "$(print_text_info 'Создайте django admin user')"
    # print_text_info2 "docker exec -it ${PROJECT_NAME}-service.drf-1 pipenv run python3 manage.py createsuperuser"
    # echo -e "Django Admin доступна адресу $(print_text_info2 http://localhost:${NGINX_PORT}/admin)"
    # echo -e ""


    # echo -e "$(print_text_info 'Наполнить базу данных тестовыми данными')"
    # print_text_info2 "docker exec -it ${PROJECT_NAME}-service.drf-1 pipenv run python3 manage.py testapp_fill_all_models"

    echo -e ""
    print_text_info "Используйте run.sh скрипт для автоматизации повседневных задач"
    echo -e "Перейдите в корневую папку проекта $(print_text_info2 ${BASE_DIR})"
    echo -e "и запустите скрипт $(print_text_info2 './run.sh') для получения дополнительной информации."
    # echo -e "Для получения дополнительной информации ознакомитесь с README.md" 
    # echo -e "https://github.com/barmaley350/start-project/blob/main/README.md"
    echo -e ""
    echo -e "   Создание django admin user"
    print_text_info2 "      ./run.sh m createsuperuser"
    echo -e "   Наполнить базу данных тестовыми данными"
    print_text_info2 "      ./run.sh m testapp_fill_all_models"    
    echo -e ""
}

# ------------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------------
main() {
    print_header
    step1_check_system_requirements
    step2_install_backend_drf
    step3_install_backend_fastapi
    step4_install_frontend
    step5_create_envs
    step6_next_steps
}

main "$@"