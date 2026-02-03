#!/bin/bash

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PATH_TO_BACKEND_DJANGO="/services/drf"
PATH_TO_BACKEND_FASTAPI="/services/fastapi"
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
    print_text_yellow "Справка по доступным командам \u00ABrun.sh\u00BB\n"
    print_text_white "./run.sh [command] [command params]\n"
    print_text_white "[command] \u2501 Основная команда либо команда быстрого доступа\n"
    print_text_white "[command params] \u2501 Любые параметы которые принимает эта комманда\n"
    line2    
    print_text_white "[command] \u2501 Основные команды \n"
    print_text_yellow "help | empty"
    print_text_white " \u2501 Вывести справку \n"
    print_text_yellow "m | manage [params]"
    print_text_white " \u2501 Запустить manage.py в backend контейнере \n"    
    print_text_yellow "p | pytest [params]"
    print_text_white " \u2501 Запустить pytest в backend контейнере \n"    
    print_text_yellow "shell"
    print_text_white " \u2501 Запустить /bin/bash в backend контейнере для ручного выполнения команд\n" 
    line2 
    print_text_white "[command] - Команды быстрого доступа\n"
    print_text_yellow "m1 | makemigrations"
    print_text_white " \u2501 Создать миграции django (mange.py makemigrations) \n"     
    print_text_yellow "m2 | migrate"
    print_text_white " \u2501 Применить миграции django (manage.py migrate) \n"         
    print_text_yellow "sd | sphinx_doc"
    print_text_white " \u2501 Сгенерировать Sphinx документацию \n" 
    print_text_yellow "rc | ruffcheck"
    print_text_white " \u2501 Запустить ruff check \n"     
    print_text_yellow "rf | ruffformat"
    print_text_white " \u2501 Запустить ruff format \n"   
    print_text_yellow "ra | ruff"
    print_text_white " \u2501 Запустить ruff check и ruff format \n"       
    print_text_yellow "fc | commit"
    print_text_white " \u2501 Запустить gendoc, ruff check, ruff format и pytest \n"      
    print_text_yellow "da | create_admin"
    print_text_white " \u2501 Создать django admin createsuperuser \n"  
    print_text_yellow "ca | create_apps [app_name]"
    print_text_white " \u2501 Создать новое приложение django \n"  
    line2 
    print_text_white "[command] - Персональные команды\n"
    print_text_yellow "g1"
    print_text_white " \u2501 git checkout main & git merge dev & \n git push gitlab dev & git push github dev & git push gitverse dev & \n git push gitlab main & git push github main & git push gitverse main\n" 
    print_text_yellow "lbd"
    print_text_white " \u2501 (backend/django) find ./apps -name "*.py" | xargs uv run pylint --rcfile=.pylintrc\n" 
    print_text_yellow "lbf"
    print_text_white " \u2501 (backend/fastapi) find ./app -name "*.py" | xargs uv run pylint --rcfile=.pylintrc\n"     
    echo -e ""
}
# pytest
command_pytest() {
    docker exec -it ${FOLDER_NAME}-service.drf-1 uv run pytest "$@"
}
# manage
command_manage() {
    docker exec -it ${FOLDER_NAME}-service.drf-1 uv run python3 manage.py "$@"
}
# makemigrations
command_makemigrations() {
    docker exec -it ${FOLDER_NAME}-service.drf-1 uv run python3 manage.py makemigrations
}
# migrate
command_migrate() {
    docker exec -it ${FOLDER_NAME}-service.drf-1 uv run python3 manage.py migrate
}
# create django admin user
command_createsuperuser() {
    docker exec -it ${FOLDER_NAME}-service.drf-1 uv run python3 manage.py createsuperuser
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
    cd $SCRIPT_DIR$PATH_TO_BACKEND_DJANGO
    rm -rf apps/sphinx_docs/docs/_build/html
    # uv run make SOURCEDIR=apps/sphinx_docs/docs BUILDDIR=apps/sphinx_docs/docs/_build/html clean
    # uv run make SOURCEDIR=apps/sphinx_docs/docs BUILDDIR=apps/sphinx_docs/docs/_build/html html
    uv run sphinx-build -b html apps/sphinx_docs/docs apps/sphinx_docs/docs/_build/html

    if [ $? -ne 0 ]; then
        print_text_block error "Ошибка при создании документации Sphinx"  
        exit $?
    fi

    print_text_block success "Генерация документации Sphinx прошла успешно"
    return 0
}


# Generate sphinx docs for backend/django
generate_graph_models() {
    cd $SCRIPT_DIR$PATH_TO_BACKEND_DJANGO
    print_text_white "Создаем graph_models testapp -o apps/sphinx_docs/docs/_static/testapp.png\n"
    uv run python3 manage.py graph_models testapp -o apps/sphinx_docs/docs/_static/testapp.png

    print_text_white "Создаем graph_models sphinx_docs -o apps/sphinx_docs/docs/_static/sphinx_docs.png\n"
    uv run python3 manage.py graph_models sphinx_docs -o apps/sphinx_docs/docs/_static/sphinx_docs.png

    print_text_white "Создаем graph_models jupyter -o apps/sphinx_docs/docs/_static/jupyter.png\n"
    uv run python3 manage.py graph_models jupyter -o apps/sphinx_docs/docs/_static/jupyter.png

    print_text_white "Создаем graph_models -o apps/sphinx_docs/docs/_static/all.png\n"
    uv run python3 manage.py graph_models -o apps/sphinx_docs/docs/_static/all.png

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
    docker exec -it ${FOLDER_NAME}-service.drf-1 uv run python3 manage.py collectstatic --noinput

    if [ $? -ne 0 ]; then
        print_text_block error "Есть ошибки при выполнении collectstatic"
        exit $?
    fi
    print_text_block success "Успешное завершение collectstatic"
    return 0
}
command_ruff_check() {
    cd $SCRIPT_DIR$PATH_TO_BACKEND_DJANGO

    uv run ruff check "$@"

    if [ $? -ne 0 ]; then
        print_text_block error "Есть ошибки при выполнении ruff check $@"
        exit $?
    fi
    print_text_block success "Успешное завершение ruff check $@"
    return 0
}

command_ruff_format() {
    # Ruff formater backend/django
    cd $SCRIPT_DIR$PATH_TO_BACKEND_DJANGO
    uv run ruff format

    if [ $? -ne 0 ]; then
        print_text_block error "сть ошибки при выполнении ruff format $@"
        exit $?
    fi
    print_text_block success "Успешное завершение ruff format $@"
}
command_django_apps() {
    cd $SCRIPT_DIR$PATH_TO_BACKEND_DJANGO
    uv run python3 manage.py startapp $@ apps/$@

    if [ $? -ne 0 ]; then
        print_text_block error "Ошибка создания приложения apps/$@"
        exit $?
    fi
    print_text_block success "Приложение apps/$@ успешно создано"
    return 0

}
command_git() {
    cd $SCRIPT_DIR
        
    git checkout main 
    git merge dev 

    git push gitlab dev
    git push github dev
    # git push gitverse dev
    git push gitlab main
    git push github main 
    # git push gitverse main
    

    git checkout dev

    if [ $? -ne 0 ]; then
        print_text_block error "Ошибка выполнения комманды git"
        exit $?
    fi
    print_text_block success "Команда git выполнилась успешно"
    return 0

}

command_pylint_django() {
    cd $SCRIPT_DIR$PATH_TO_BACKEND_DJANGO
        
    find ./apps -name "*.py" | xargs uv run pylint --rcfile=.pylintrc

    if [ $? -ne 0 ]; then
        print_text_block error "Ошибка выполнения комманды backend/django/pylint"
        exit $?
    fi
    print_text_block success "Команда backend/django/pylint выполнилась успешно"
    return 0
}

command_pylint_fastapi() {
    cd $SCRIPT_DIR$PATH_TO_BACKEND_FASTAPI
        
    find ./app -name "*.py" | xargs uv run pylint --rcfile=.pylintrc

    if [ $? -ne 0 ]; then
        print_text_block error "Ошибка выполнения комманды backend/fastapi/pylint"
        exit $?
    fi
    print_text_block success "Команда backend/fastapi/pylint выполнилась успешно"
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
        g1)
            command_git $@
            ;;       
        lbf)
            command_pylint_fastapi $@
            ;;     
        lbd)
            command_pylint_django $@
            ;;                                                                                                               
        *)
            print_text_error "Не известная комманда - $command"
            ;;        
    esac    
}

main "$@" 