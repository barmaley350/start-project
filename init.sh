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
    echo -e "-------------------------------------------------------------------------"
    echo -e "     Настройка проекта ${YELLOW}\u00AB${PROJECT_NAME}\u00BB${NC}"
    echo -e "-------------------------------------------------------------------------"
    echo -e "${YELLOW}Шаг 1${NC} - проверка установленных зависимостей docker, nodejs, npm, pipenv"
    echo -e "   Без вашего ведома ничего не устанавливается."
    echo -e "   Проверяется только наличие необходимых программ."             
    echo -e "${YELLOW}Шаг 2${NC} - настройка backend (pipenv sync --dev)"       
    echo -e "${YELLOW}Шаг 3${NC} - настройка frontend (npm install)"
    echo -e "${YELLOW}Шаг 4${NC} - настройка переменных окружения для backend/frontend"
    echo -e "${YELLOW}Шаг 5${NC} - настройка docker (docker compose up --build)"
    echo -e "   Данный шаг можно не выполнять и запустить в ручном режиме."
    echo -e "-------------------------------------------------------------------------"
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
    print_success "Все зависимости установлены"
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
    print_info "Шаг 5 - Сейчас мы выполним настройку \u00ABdocker\u00BB"
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
    print_info "Шаг 4 - Сейчас мы выполним настройку \u00ABbackend/.env\u00BB и \u00ABfrontend/.env\u00BB"
    echo "Для (frontend) мы выполним следующие действия:"
    echo -e "\u2014 Перейдем в каталог ${BLUE}${FRONTEND_DIR_DIR}${NC}"
    echo -e "\u2014 Выполним команду ${BLUE}cp .env.example .env${NC}"
    echo ""
    echo "Для (backend) мы выполним следующие действия:"
    echo -e "\u2014 Перейдем в каталог ${BLUE}${BACKEND_DIR}${NC}"
    echo -e "\u2014 Выполним команду ${BLUE}cp .env.example .env${NC}"
    echo -e "\u2014 Настроим ${BLUE}SECRET_KEY${NC} и ${BLUE}POSTGRES_PASSWORD${NC}"
    echo "Все остальные параметры останутся со значениями по умолчанию."
    echo -e "Вы всегда сможете изменить эти параметры в файле ${BLUE}services/backend/.env${NC}"
    
    read -rp $'\nПродолжаем настройку? (y/N): ' confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || { print_info "Отмена."; exit 0; }
}

create_backend() {

    cd $BACKEND_DIR

    if pipenv sync; then
        echo "---------------------------------------"
        print_success "pipenv sync успешно выполнен"
        echo "---------------------------------------"
        return 0
    else
        print_error "Ошибка при запуске pipenv sync."
        return 1
    fi
}

create_frontend() {

    cd $FRONTEND_DIR
    
    if npm install; then
        echo "---------------------------------------"
        print_success "npm install успешно выполнен"
        echo "---------------------------------------"
        return 0
    else
        print_error "Ошибка при запуске npm install."
        return 1
    fi
}

create_docker() {

    cd $BASE_DIR
    
    if docker compose up --build; then
        echo "---------------------------------------"
        print_success "docker compose up --build успешно выполнен"
        echo "---------------------------------------"
        return 0
    else
        print_error "Ошибка при запуске docker compose up --build."
        return 1
    fi
}

create_env_frontend() {

    cd $FRONTEND_DIR
    cp .env.example .env
}

create_env_backend() {

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
    confirm_creation_docker
    create_docker
}

main "$@"