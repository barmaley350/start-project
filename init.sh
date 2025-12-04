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

print_header() {
    echo -e "_________________________________________________________________________"
    echo -e ""
    echo -e "Настройка проекта ${YELLOW}\u00AB${PROJECT_NAME}\u00BB${NC}"
    echo -e "_________________________________________________________________________"
    echo -e "${YELLOW}Шаг 1${NC} - проверка установленных зависимостей docker, nodejs, npm, pipenv"
    echo -e "Без вашего ведома ничего не устанавливается."
    echo -e "Проверяется только наличие необходимых программ."             
    echo -e "${YELLOW}Шаг 2${NC} - настройка backend (pipenv sync --dev)"       
    echo -e "${YELLOW}Шаг 3${NC} - настройка frontend (npm install)"
    echo -e "${YELLOW}Шаг 4${NC} - настройка переменных окружения для backend/frontend"
    echo -e "${YELLOW}Шаг 5${NC} - настройка переменных окружения для docker (.env)"
    echo -e "_________________________________________________________________________"
}

print_success() {
    echo -e "${GREEN} \u2714 $1${NC}"
}

print_error() {
    echo -e "${RED} \u2718 $1${NC}"
}

print_info() {
    echo -e "${YELLOW}$1${NC}"
}

print_info2() {
    echo -e "${BLUE}$1${NC}"
}

check_requirements() {
    echo -e "${YELLOW}Шаг 1 - Проверка зависимостей... ${NC}"

    if ! command -v docker &> /dev/null; then
        print_error "docker не установлен. Установите docker https://docs.docker.com/desktop/setup/install/linux/ubuntu/"
        echo ""
        exit 1
    fi
    print_success "Docker установлен"

    if ! command -v node &> /dev/null; then
        print_error "Node.js не установлен. Установите nodejs https://nodejs.org/en/download"
        echo ""
        exit 1
    fi
    print_success "Node.js установлен"

    if ! command -v npm &> /dev/null; then
        print_error "npm не установлен. Установите npm https://nodejs.org/en/download"
        echo ""
        exit 1
    fi
    print_success "npm установлен"

    if ! command -v pipenv &> /dev/null; then
        print_error "pipenv не установлен. Установите pipenv https://pipenv.pypa.io/en/latest/installation.html"
        echo ""
        exit 1
    fi
    print_success "pipenv установлен"

    echo -e "_________________________________________________________________________"
    echo -e ""
    print_success "Все зависимости установлены"
    echo -e "_________________________________________________________________________"
}

confirm_creation_backend() {
    echo ""
    print_info "Шаг 2 - Сейчас мы выполним настройку \u00ABbackend\u00BB"
    echo "Для этого мы выполним следующие действия:"
    echo -e "\u2014 Перейдем в каталог ${BLUE}${BACKEND_DIR}${NC}"
    echo -e "\u2014 Выполним команду ${BLUE}pipenv sync --dev${NC}"

    read -rp $'\nПродолжаем настройку? (y/N): ' confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || { print_info "Отмена."; exit 0; }
}

confirm_creation_frontend() {
    echo ""
    print_info "Шаг 3 - Сейчас мы выполним настройку \u00ABfrontend\u00BB"
    echo "Для этого мы выполним следующие действия:"
    echo -e "\u2014 Перейдем в каталог ${BLUE}${FRONTEND_DIR}${NC}"
    echo -e "\u2014 Выполним команду ${BLUE}npm install${NC}"
    
    read -rp $'\nПродолжаем настройку? (y/N): ' confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || { print_info "Отмена."; exit 0; }
}

confirm_creation_docker() {
    echo ""
    print_info "Шаг 5 - Все готово! Пробуем запустить \u00ABdocker\u00BB"
    echo "Для этого мы выполним следующие действия:"
    echo -e "\u2014 Перейдем в каталог ${BLUE}${BASE_DIR}${NC}"
    echo -e "\u2014 Выполним команду ${BLUE}docker compose up --build${NC}"
    echo -e ""
    echo -e "Если все прошло успешно то проект будет доступен ${GREEN}http://localhost:1338/${NC}"
    echo -e "Если что-то пошло не так - прочитайте README.md"

    read -rp $'\nПродолжаем настройку? (y/N): ' confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || { print_info "Отмена."; exit 0; }
}

confirm_creation_env() {
    echo ""
    print_info "Шаг 4 - Сейчас мы выполним настройку переменных окружения для"
    print_info "\u00ABbackend (services/backend/.env)\u00BB, \u00ABfrontend (services/frontend/.env)\u00BB и \u00ABdocker (.env)\u00BB"
    echo "Для (frontend) мы выполним следующие действия:"
    echo -e "\u2014 Перейдем в каталог ${BLUE}${FRONTEND_DIR}${NC}"
    echo -e "\u2014 Выполним команду ${BLUE}cp .env.example .env${NC}"
    echo ""
    echo "Для (backend) мы выполним следующие действия:"
    echo -e "\u2014 Перейдем в каталог ${BLUE}${BACKEND_DIR}${NC}"
    echo -e "\u2014 Выполним команду ${BLUE}cp .env.example .env${NC}"
    echo -e "\u2014 Настроим ${BLUE}SECRET_KEY${NC} и ${BLUE}POSTGRES_PASSWORD${NC}"
    echo "Все остальные параметры останутся со значениями по умолчанию."
    echo -e "Вы всегда сможете изменить эти параметры в файле ${BLUE}services/backend/.env${NC}"
    echo ""
    echo "Для (docker) мы выполним следующие действия:"
    echo -e "\u2014 Перейдем в каталог ${BLUE}${BASE_DIR}${NC}"
    echo -e "\u2014 Выполним команду ${BLUE}cp .env.example .env${NC}"
    echo -e "\u2014 Настроим ${BLUE}NGINX_PORT${NC} (по умолчанию 1338) и ${BLUE}ADMINER_PORT${NC} (по умолчанию 8099)"
    echo "Все остальные параметры сформируются автоматически."
    echo -e "Вы всегда сможете изменить эти параметры в файле ${BLUE}.env${NC} в корне проекта."
    echo -e "После самостоятельного внесенных изменений нужно выполнить ${BLUE}docker compose up --build${NC}."
    
    read -rp $'\nПродолжаем настройку? (y/N): ' confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || { print_info "Отмена."; exit 0; }
}

create_backend() {
    cd $BACKEND_DIR

    if pipenv sync; then
        echo -e "_________________________________________________________________________"
        echo -e ""
        print_success "pipenv sync успешно выполнен"
        echo -e "_________________________________________________________________________"
        return 0
    else
        echo -e "_________________________________________________________________________"
        echo -e ""
        print_error "Ошибка при запуске pipenv sync."
        echo -e "_________________________________________________________________________"
        return 1
    fi
}

create_frontend() {

    cd $FRONTEND_DIR
    
    if npm install; then
        echo -e "_________________________________________________________________________"
        echo -e ""
        print_success "npm install успешно выполнен"
        echo -e "_________________________________________________________________________"
        return 0
    else
        echo -e "_________________________________________________________________________"
        echo ""
        print_error "Ошибка при запуске npm install."
        echo -e "_________________________________________________________________________"
        return 1
    fi
}

create_docker() {

    cd $BASE_DIR
    
    if docker compose up --build; then
        echo -e "_________________________________________________________________________"
        echo -e ""
        print_success "docker compose up --build успешно выполнен"
        echo -e "_________________________________________________________________________"
        return 0
    else
        echo -e "_________________________________________________________________________"
        echo -e ""
        print_error "Ошибка при запуске docker compose up --build."
        echo -e "_________________________________________________________________________"
        return 1
    fi
}

create_env_frontend() {
    print_info "Настрока параметров окружения для frontend"

    cd $FRONTEND_DIR
    cp .env.example .env
}

create_env_backend() {
    print_info "Настрока параметров окружения для backend"

    cd $BACKEND_DIR

    local SECRET_KEY_DEFAULT=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 16)
    local POSTGRES_PASSWORD_DEFAULT=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 16)

    cp .env.example .env

    read -rp $' \u00BB Укажите SECRET_KEY (по умолчанию: '"$SECRET_KEY_DEFAULT"'): ' secret_key_value

    SECRET_KEY="${secret_key_value:-$SECRET_KEY_DEFAULT}"

    read -rp $' \u00BB Укажите POSTGRES_PASSWORD (по умолчанию: '"$POSTGRES_PASSWORD_DEFAULT"'): ' postgres_password_value
    POSTGRES_PASSWORD="${postgres_password_value:-$POSTGRES_PASSWORD_DEFAULT}"

    sed -i "s|^SECRET_KEY=.*|SECRET_KEY=\"$SECRET_KEY\"|" .env
    sed -i "s|^POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=\"$POSTGRES_PASSWORD\"|" .env

}

create_env_docker() {
    print_info "Настрока параметров окружения для docker"

    cd $BASE_DIR

    local DB_VOLUME_NAME="$PROJECT_NAME-db-volume"
    local STATIC_VOLUME_NAME="$PROJECT_NAME-static-volume"

    local NGINX_PORT_DEFAULT=1338
    local ADMINER_PORT_DEFAULT=8099

    cp .env.example .env

    read -rp $' \u00BB Укажите NGINX_PORT (по умолчанию: '"$NGINX_PORT_DEFAULT"'): ' nginx_port_value

    NGINX_PORT="${nginx_port_value:-$NGINX_PORT_DEFAULT}"

    read -rp $' \u00BB Укажите ADMINER_PORT (по умолчанию: '"$ADMINER_PORT_DEFAULT"'): ' adminer_port_value
    ADMINER_PORT="${adminer_port_value:-$ADMINER_PORT_DEFAULT}"

    sed -i "s|^NGINX_PORT=.*|NGINX_PORT=$NGINX_PORT|" .env
    sed -i "s|^ADMINER_PORT=.*|ADMINER_PORT=$ADMINER_PORT|" .env
    sed -i "s|^DB_VOLUME_NAME=.*|DB_VOLUME_NAME=\"$DB_VOLUME_NAME\"|" .env
    sed -i "s|^STATIC_VOLUME_NAME=.*|STATIC_VOLUME_NAME=\"$STATIC_VOLUME_NAME\"|" .env
}

next_steps() {
    echo -e ""
    echo -e "_________________________________________________________________________"
    echo -e ""
    print_success "Настройка проекта ${YELLOW}\u00AB${PROJECT_NAME}\u00BB${NC} завершена!" 
    echo -e "_________________________________________________________________________"
    echo -e "${YELLOW}Шаг 1${NC}" 
    echo -e "В корневом каталоге проекта выполните комманду ${BLUE}docker compose up --build${NC}"
    echo -e "Убедитесь что все отработало и сайт доступен по адресу ${BLUE}http://localhost:${NGINX_PORT}${NC}"
    echo -e ""
    echo -e "${YELLOW}Шаг 2${NC} - создание django admin user"
    echo -e "${BLUE}docker exec -it ${PROJECT_NAME}-service.backend-1 pipenv run python3 manage.py createsuperuser${NC}"
    # echo -e "Подробная инструкция тут --- "
    echo -e ""
    echo -e "${YELLOW}Шаг 3${NC} - наполнить базу данных demo данными"
    echo -e "${BLUE}docker exec -it ${PROJECT_NAME}-service.backend-1 pipenv run python3 manage.py shell_plus${NC}" 
    echo -e ">>> ${BLUE}ProjectFactory.create_batch(100)${NC}"
    echo -e ">>> ${BLUE}Project.objects.count()${NC}"
    echo -e ">>> 100"
    echo -e ">>> Ctrl+C"
    # echo -e "Подробная инструкция тут --- "
    echo -e "_________________________________________________________________________"
    echo -e ""
    print_success "Удачи! Всегда открыт PR ;)"  
    echo -e "_________________________________________________________________________"  
    echo -e ""
}

main() {
    print_header
    check_requirements
    confirm_creation_backend
    create_backend
    confirm_creation_frontend
    create_frontend
    confirm_creation_env
    create_env_frontend
    create_env_backend
    create_env_docker
    # confirm_creation_docker
    # create_docker
    next_steps
}

main "$@"