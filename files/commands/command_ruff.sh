#!/bin/bash

command_ruff_check_drf() {
    cd $SCRIPT_DIR$PATH_TO_BACKEND_DJANGO
    uv run ruff check $USER_PARAMS
    check_command_run_status $? "Выполнение ruff check $USER_PARAMS для backend/drf"
}


command_ruff_format_drf() {
    cd $SCRIPT_DIR$PATH_TO_BACKEND_DJANGO
    uv run ruff format
    check_command_run_status $? "Выполнение ruff format для backend/drf"
}

command_ruff_check_fastapi() {
    cd $SCRIPT_DIR$PATH_TO_BACKEND_FASTAPI
    uv run ruff check $USER_PARAMS
    check_command_run_status $? "Выполнение ruff check $USER_PARAMS для backend/fastapi"
}

command_ruff_format_fastapi() {
    cd $SCRIPT_DIR$PATH_TO_BACKEND_FASTAPI
    uv run ruff format
    check_command_run_status $? "Выполнение ruff format для backend/fastapi"
}