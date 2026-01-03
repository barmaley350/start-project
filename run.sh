#!/bin/bash

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PATH_TO_BACKEND="/services/drf"
PATH_TO_BACKEND_DOCS="/services/drf/apps/sphinx_docs/docs"

# Абсолютный путь к каталогу скрипта
SCRIPT_DIR=$(cd -P "$(dirname -- "$0")" && pwd -P)

# Извлекаем только имя папки из полного пути
FOLDER_NAME=$(basename "$SCRIPT_DIR")

# text success
print_text_green() { 
    echo -en "${GREEN} \u2714 $1${NC}" 
}
# text error
print_text_red() {
    echo -en "${RED} \u2718 $1${NC}"
}
# text yellow
print_text_yellow() {
    echo -en "${YELLOW}$1${NC}"
}
# text blue
print_text_blue() {
    echo -en "${BLUE}$1${NC}"
}
# text white
print_text_white() {
    echo -en "$1"
}
print_text_block() {
    case $1 in
        success)
            line
            print_text_green "$2 \n" 
            line
            ;;
        error)
            line
            print_text_red "$2 \n"
            line
            ;;
    esac
}
# lines
line() {
    cols=$(tput cols)
    for ((i=1; i<=cols; i++)); do echo -en "\u2500"; done
    echo -e ""
}
line2() {
    cols=$(tput cols)
    for ((i=1; i<=cols; i++)); do echo -en "\u2500"; done
    echo -e ""
}

# help 
help() {
    
    line
    print_text_yellow "Справка по доступным командам\n"
    print_text_white "./run.sh [command] [command params]\n"
    print_text_white "[command] - Основная команда либо команда быстрого доступа\n"
    print_text_white "[command params] - Любые параметы которые принимает эта комманда\n"
    line2    
    print_text_white "[command] - основные команды \n"
    print_text_blue "help | empty"
    print_text_white " \u2501 Вывести справку \n"
    print_text_blue "m | manage [params]"
    print_text_white " \u2501 Запустить manage.py в backend контейнере \n"    
    print_text_blue "p | pytest [params]"
    print_text_white " \u2501 Запустить pytest в backend контейнере \n"    
    print_text_blue "shell"
    print_text_white " \u2501 Запустить /bin/bash в backend контейнере для ручного выполнения команд\n" 
    line2 
    print_text_white "[command] - Команды быстрого доступа\n"
    print_text_blue "m1 | makemigrations"
    print_text_white " \u2501 Создать миграции django (mange.py makemigrations) \n"     
    print_text_blue "m2 | migrate"
    print_text_white " \u2501 Применить миграции django (manage.py migrate) \n"         
    print_text_blue "sd | sphinx_doc"
    print_text_white " \u2501 Сгенерировать Sphinx документацию \n" 
    print_text_blue "rc | ruffcheck"
    print_text_white " \u2501 Запустить ruff check \n"     
    print_text_blue "rf | ruffformat"
    print_text_white " \u2501 Запустить ruff format \n"   
    print_text_blue "ra | ruff"
    print_text_white " \u2501 Запустить ruff check и ruff format \n"       
    print_text_blue "fc | commit"
    print_text_white " \u2501 Запустить gendoc, ruff check, ruff format и pytest \n"      
    print_text_blue "da | create_admin"
    print_text_white " \u2501 Создать django admin createsuperuser \n"  
    print_text_blue "ca | create_apps [app_name]"
    print_text_white " \u2501 Создать новое приложение django \n"  
    echo -e ""
}
# pytest
command_pytest() {
    docker exec -it ${FOLDER_NAME}-service.drf-1 pipenv run pytest "$@"
}
# manage
command_manage() {
    docker exec -it ${FOLDER_NAME}-service.drf-1 pipenv run python3 manage.py "$@"
}
# makemigrations
command_makemigrations() {
    docker exec -it ${FOLDER_NAME}-service.drf-1 pipenv run python3 manage.py makemigrations
}
# migrate
command_migrate() {
    docker exec -it ${FOLDER_NAME}-service.drf-1 pipenv run python3 manage.py migrate
}
# create django admin user
command_createsuperuser() {
    docker exec -it ${FOLDER_NAME}-service.drf-1 pipenv run python3 manage.py createsuperuser
}
# docker shell
command_shell() {
    docker exec -it ${FOLDER_NAME}-service.drf-1 /bin/bash
}
# docker shell
command_shell() {
    docker exec -it ${FOLDER_NAME}-service.drf-1 /bin/bash
}
# gendoc
command_gendoc() {
    generate_graph_models
    generate_sphinx_docs
    command_collectstatic
} 
generate_sphinx_docs() {
    # cd $SCRIPT_DIR$PATH_TO_BACKEND_DOCS
    cd $SCRIPT_DIR$PATH_TO_BACKEND
    rm -rf apps/sphinx_docs/docs/_build/html
    # pipenv run make SOURCEDIR=apps/sphinx_docs/docs BUILDDIR=apps/sphinx_docs/docs/_build/html clean
    # pipenv run make SOURCEDIR=apps/sphinx_docs/docs BUILDDIR=apps/sphinx_docs/docs/_build/html html
    pipenv run sphinx-build -b html apps/sphinx_docs/docs apps/sphinx_docs/docs/_build/html

    if [ $? -ne 0 ]; then
        print_text_block error "Ошибка при создании документации Sphinx"  
        exit $?
    fi

    print_text_block success "Генерация документации Sphinx прошла успешно"
    return 0
}


# Generate sphinx docs for backend/django
generate_graph_models() {
    cd $SCRIPT_DIR$PATH_TO_BACKEND
    print_text_white "Создаем graph_models testapp -o apps/sphinx_docs/docs/_static/testapp.png\n"
    pipenv run python3 manage.py graph_models testapp -o apps/sphinx_docs/docs/_static/testapp.png

    print_text_white "Создаем graph_models sphinx_docs -o apps/sphinx_docs/docs/_static/sphinx_docs.png\n"
    pipenv run python3 manage.py graph_models sphinx_docs -o apps/sphinx_docs/docs/_static/sphinx_docs.png

    print_text_white "Создаем graph_models jupyter -o apps/sphinx_docs/docs/_static/jupyter.png\n"
    pipenv run python3 manage.py graph_models jupyter -o apps/sphinx_docs/docs/_static/jupyter.png

    print_text_white "Создаем graph_models -o apps/sphinx_docs/docs/_static/all.png\n"
    pipenv run python3 manage.py graph_models -o apps/sphinx_docs/docs/_static/all.png

    if [ $? -ne 0 ]; then
        print_text_block error "Генерация graph_models структуры DB завершилась с ошибкой"
        exit $?
    fi
    cp apps/sphinx_docs/docs/_static/* $SCRIPT_DIR/files/img/graph_models

    print_text_block success "Генерация graph_models структуры DB прошла успешно"
    return 0
}
# collectstatic
command_collectstatic() {
    docker exec -it ${FOLDER_NAME}-service.drf-1 pipenv run python3 manage.py collectstatic --noinput

    if [ $? -ne 0 ]; then
        print_text_block error "Есть ошибки при выполнении collectstatic"
        exit $?
    fi
    print_text_block success "Успешное завершение collectstatic"
    return 0
}
command_ruff_check() {
    cd $SCRIPT_DIR$PATH_TO_BACKEND

    pipenv run ruff check "$@"

    if [ $? -ne 0 ]; then
        print_text_block error "Есть ошибки при выполнении ruff check $@"
        exit $?
    fi
    print_text_block success "Успешное завершение ruff check $@"
    return 0
}

command_ruff_format() {
    # Ruff formater backend/django
    cd $SCRIPT_DIR$PATH_TO_BACKEND
    pipenv run ruff format

    if [ $? -ne 0 ]; then
        print_text_block error "сть ошибки при выполнении ruff format $@"
        exit $?
    fi
    print_text_block success "Успешное завершение ruff format $@"
}
command_django_apps() {
    cd $SCRIPT_DIR$PATH_TO_BACKEND
    pipenv run python3 manage.py startapp $@ apps/$@

    if [ $? -ne 0 ]; then
        print_text_block error "Ошибка создания приложения apps/$@"
        exit $?
    fi
    print_text_block success "Приложение apps/$@ успешно создано"
    return 0

}
command_ruff_all() {
    command_ruff_check
    command_ruff_format
}
# commit
command_commit() {
    command_gendoc
    command_ruff_all
    command_pytest
}
# main
main() {
    if [ $# -eq 0 ]; then
        help
        exit 0
    fi

    command=$1
    shift

    case $command in
        help)
            help "$@"
            ;;    
        shell)
            command_shell "$@"
            ;;
        m | manage)
            command_manage "$@"
            ;;  
        pytest)
            command_pytest "$@"
            ;;     
        sd | sphinx_doc)
            command_gendoc "$@"
            ;;    
        rc | ruffcheck)
            command_ruff_check "$@"
            ;;   
        rf | ruffformat)
            command_ruff_format "$@"
            ;;   
        ra | ruff)
            command_ruff_all
            ;;      
        fc | commit)
            command_commit
            ;;    
        m1 | makemigrations)
            command_makemigrations
            ;;     
        m2 | migrate)
            command_migrate
            ;; 
        da | create_admin)
            command_createsuperuser
            ;;    
        ca | create_apps)
            command_django_apps $@
            ;;                                                                                                 
        *)
            print_text_error "Не известная комманда - $command"
            ;;        
    esac    
}

main "$@" 