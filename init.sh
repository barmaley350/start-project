#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

BASE_DIR=$(pwd)
BACKEND_DIR="${BASE_DIR}/services/backend"
FRONTEND_DIR="${BASE_DIR}/services/frontend"

PROJECT_NAME=$(basename "$PWD")

NGINX_PORT=1338
ADMINER_PORT=8099

# 
print_header() {
    clear_screen
    print_text_block empty "$(print_text_success "Настройка проекта \u00AB${PROJECT_NAME}\u00BB")"
    echo -e "$(print_text_info 'Шаг 1') - проверка установленных зависимостей docker, nodejs, npm, pipenv"
    echo -e "Без вашего ведома ничего не устанавливается."
    echo -e "Проверяется только наличие необходимых программ."             
    echo -e "$(print_text_info 'Шаг 2') - настройка backend (pipenv sync --dev)"       
    echo -e "$(print_text_info 'Шаг 3') - настройка frontend (npm install)"
    echo -e "$(print_text_info 'Шаг 4') - настройка переменных окружения для backend/frontend/docker"
    echo -e "$(print_text_info 'Шаг 5') - что дальше?"

    confirm_to_continue "Переходим к шагу 1 (проверка зависимостей)?"
    
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
# confirm_to_continue ---------------------
confirm_to_continue() {
    prompt="${1:-"Продолжить выполнение?"}"
    echo ""
    read -rp $"${prompt} (Enter/any key to exit): " confirm
    [[ -z "$confirm" || "$confirm" =~ ^[Yy]$ ]] || { print_text_info "Отмена."; exit 0; }
}

# step1_check_system_requirements ---------------------
step1_check_system_requirements() {
    clear_screen
    print_text_block info "Шаг 1 - Проверка зависимостей"

    if ! command -v docker &> /dev/null; then
        print_text_error "docker не установлен. Установите docker https://docs.docker.com/desktop/setup/install/linux/ubuntu/"
        echo ""
        exit 1
    fi
    print_text_success "Docker установлен"

    if ! command -v node &> /dev/null; then
        print_text_error "Node.js не установлен. Установите nodejs https://nodejs.org/en/download"
        echo ""
        exit 1
    fi
    print_text_success "Node.js установлен"

    if ! command -v npm &> /dev/null; then
        print_text_error "npm не установлен. Установите npm https://nodejs.org/en/download"
        echo ""
        exit 1
    fi
    print_text_success "npm установлен"

    if ! command -v pipenv &> /dev/null; then
        print_text_error "pipenv не установлен. Установите pipenv https://pipenv.pypa.io/en/latest/installation.html"
        echo ""
        exit 1
    fi
    print_text_success "pipenv установлен"
    print_text_block success "Шаг 1 - выполнен"
    confirm_to_continue "Переходим к шагу 2 (настройка backend)?"
}

# BEGIN backend ---------------------
confirm_creation_backend() {
    clear_screen
    print_text_block info "Шаг 2 - Сейчас мы выполним настройку \u00ABbackend\u00BB"
    echo "Для этого мы выполним следующие действия:"
    echo -e "\u2014 Перейдем в каталог $(print_text_info2 ${BACKEND_DIR})"
    echo -e "\u2014 Выполним команду $(print_text_info2 'pipenv sync --dev')"

    confirm_to_continue
}

step2_install_backend() {
    cd $BACKEND_DIR

    clear_screen
    confirm_creation_backend

    if pipenv sync --dev; then
        print_text_block success "Шаг 2 - выполнен. pipenv sync --dev успешно выполнен"
        confirm_to_continue "Переходим к шагу 3 (настройка frontend)?"
        return 0
    else
        print_text_block error "Возникли ошибки при выполении pipenv sync --dev"
        return 1
    fi
}
# END backend ---------------------

# BEGIN frontend
confirm_creation_frontend() {
    clear_screen
    print_text_block info "Шаг 3 - Сейчас мы выполним настройку \u00ABfrontend\u00BB"
    echo "Для этого мы выполним следующие действия:"
    echo -e "\u2014 Перейдем в каталог $(print_text_info2 ${FRONTEND_DIR})"
    echo -e "\u2014 Выполним команду $(print_text_info2 'npm install')"
    
    confirm_to_continue 
}

step3_install_frontend() {
    cd $FRONTEND_DIR

    clear_screen
    confirm_creation_frontend

    if npm install; then
        print_text_block success "Шаг 3 - выполнен. npm install успешно выполнен"
        confirm_to_continue "Переходим к шагу 4 (настройка переменных окружения)?"
        return 0
    else
        print_text_block error "Ошибка при запуске npm install"
        return 1
    fi
}
# END frontend

#BEGIN create env for backend
confirm_creation_env1() {
    clear_screen
    print_text_block info "Шаг 4 - Настройка переменных окружения"
    echo "Для (frontend) мы выполним следующие действия:"
    echo -e "\u2014 Перейдем в каталог  $(print_text_info2 ${FRONTEND_DIR})"
    echo -e "\u2014 Выполним команду  $(print_text_info2 'cp .env.example .env')"

    echo ""
    echo "Для (backend) мы выполним следующие действия:"
    echo -e "\u2014 Перейдем в каталог  $(print_text_info2 ${BACKEND_DIR})"
    echo -e "\u2014 Выполним команду $(print_text_info2 'cp .env.example .env')"
    echo -e "\u2014 Настроим $(print_text_info2 'SECRET_KEY') и $(print_text_info2 'POSTGRES_PASSWORD')"
    echo -e "Вы всегда сможете изменить эти параметры в файле $(print_text_info2 'services/backend/.env')"

    echo ""
    echo "Для (docker) мы выполним следующие действия:"
    echo -e "\u2014 Перейдем в каталог $(print_text_info2 ${BASE_DIR})"
    echo -e "\u2014 Выполним команду $(print_text_info2 'cp .env.example .env')"
    echo -e "\u2014 Настроим $(print_text_info2 'NGINX_PORT') (по умолчанию ${NGINX_PORT}) и $(print_text_info2 'ADMINER_PORT') (по умолчанию ${ADMINER_PORT})"
    echo -e "Вы всегда сможете изменить эти параметры в файле $(print_text_info2 '.env') в корне проекта."

    confirm_to_continue
}

check_if_env_exist_or_not_text() {
    case $1 in
        exist)
            echo -e "Файл $(print_text_info2 ${2}/.env) существует"
            echo -e "Настройки по умолчанию берутся из этого файла"
            echo -e "Если какие-то настройки уже существуют в этом файле, то они сохранят свои значения"
            ;;
        copy)
            echo -e "Файл $(print_text_info2 ${2}/.env) не существует"
            echo -e "Файл $(print_text_info2 '.env.example') скопирован в $(print_text_info2 '.env')"
            ;;
        error)
            print_text_error "Файл .env.example не существует"
            echo -e "Каталог - ${2}"
            echo -e "Проверьте наличие файла $(print_text_info2 '.env.example') в указанном каталоге"
            echo -e ""
            ;;
    esac
}

create_env_frontend() {
    clear_screen
    print_text_block info "Настройка параметров окружения для frontend"

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

    print_text_block success "Настройка параметров окружения для frontend завершена"
    confirm_to_continue
}

create_env_backend2() {
    clear_screen
    print_text_block info "Настройка параметров окружения для backend"

    cd $BACKEND_DIR

    if [ -e ".env.example" ]; then
        if [ -e ".env" ]; then
            . .env

            check_if_env_exist_or_not_text exist $BACKEND_DIR
        else
            cp .env.example .env
            check_if_env_exist_or_not_text copy $BACKEND_DIR
            local SECRET_KEY=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 16)
            local POSTGRES_PASSWORD=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 16)
        fi
    else
        check_if_env_exist_or_not_text error $BACKEND_DIR
        return 1
    fi

    echo -e ""
    read -rp $' \u00BB Укажите SECRET_KEY (по умолчанию: '"$SECRET_KEY"'): ' secret_key_value

    SECRET_KEY="${secret_key_value:-$SECRET_KEY}"

    read -rp $' \u00BB Укажите POSTGRES_PASSWORD (по умолчанию: '"$POSTGRES_PASSWORD"'): ' postgres_password_value
    POSTGRES_PASSWORD="${postgres_password_value:-$POSTGRES_PASSWORD}"

    sed -i "s|^SECRET_KEY=.*|SECRET_KEY=\"$SECRET_KEY\"|" .env
    sed -i "s|^POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=\"$POSTGRES_PASSWORD\"|" .env

    print_text_block success "Настройка параметров окружения для backend завершена"
    confirm_to_continue
}

create_env_docker2() {
    clear_screen
    print_text_block info "Настройка параметров окружения для docker"

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

    print_text_block success "Настройка параметров окружения для docker завершена"
    confirm_to_continue
}

step4_create_envs() {
    confirm_creation_env1
    create_env_frontend
    create_env_backend2
    create_env_docker2
}

next_steps() {
    clear_screen
    print_text_block empty "$(print_text_success "Настройка проекта \u00AB${PROJECT_NAME}\u00BB завершена! Что дальше?")"

    echo -e "$(print_text_info 'Запустите docker')"
    echo -e "Перейдите в $(print_text_info2 ${BASE_DIR})"
    echo -e "Выполните комманду $(print_text_info2 'docker compose up --build')"
    echo -e "Убедитесь что все отработало и сайт доступен по адресу $(print_text_info2 http://localhost:${NGINX_PORT})"
    echo -e ""

    echo -e "$(print_text_info 'Создайте django admin user')"
    print_text_info2 "docker exec -it ${PROJECT_NAME}-service.backend-1 pipenv run python3 manage.py createsuperuser"
    echo -e "Django Admin доступна адресу $(print_text_info2 http://localhost:${NGINX_PORT}/admin)"
    echo -e ""


    echo -e "$(print_text_info 'Наполнить базу данных тестовыми данными')"
    print_text_info2 "docker exec -it ${PROJECT_NAME}-service.backend-1 pipenv run python3 manage.py filling_models"

    echo -e ""
    print_text_info "Для получения дополнительной информации ознакомитесь с README.md"  
    echo -e "https://github.com/barmaley350/start-project/blob/main/README.md"
    echo -e ""
}

main() {
    print_header
    step1_check_system_requirements
    step2_install_backend
    step3_install_frontend
    step4_create_envs
    next_steps
}

main "$@"