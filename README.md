# Оглавление
- [Что это такое и зачем это нужно](#что-это-такое-и-зачем-это-нужно)
- [Общая схема работы](#общая-схема-работы)
- [Нагрузочные тесты](#нагрузочные-тесты)
- [Схема DB](#схема-db)
- [Доступные сервисы](#доступные-сервисы)
- [Установленные и настроенные модули](#установленные-и-настроенные-модули)
  - [Backend/Django](#backend-django)
  - [Backend/FastApi](#backend-fastapi)
  - [Frontend/Nuxtjs](#frontend-nuxtjs)
- [Что нужно для локальной работы](#что-нужно-для-локальной-работы)
- [Установка](#установка)
- [Настройка](#настройка)
  - [Автоматическая настройка с использованием init.sh](#автоматическая-настройка-с-использованием-initsh)
  - [Настройка в ручном режиме](#настройка-в-ручном-режиме)
    - [Backend/DRF](#настройки-backenddrf)
    - [Backend/FastAPI](#настройки-backendfastapi)
    - [Frontend/NuxtJS](#настройки-frontendnuxtjs)
    - [Docker (опционально)](#настройки-docker)
- [Первый запуск](#первый-запуск)
  - [Запустить Docker](#запустить-docker)
  - [Создать django superuser](#создать-django-superuser)
  - [Наполнить базу тестовыми данными](#наполнить-базу-тестовыми-данными)
- [Настройка git pre-commit](#настройка-git-pre-commit)
- [Настройка и использование run.sh](#настройка-и-использование-runsh)
- [License](#license)

# Что это такое и зачем это нужно
Стартовый проект, который включает в себя все необходимые базовые компоненты для начала разработки web-проекта в рамках микросервисной архитектуры. Вам не нужно тратить время на установку и настройку окружения — всё необходимое уже включено и настроено.

Всё тестировалось и запускалось только на Linux/Ubuntu. Тестирования на Win/Mac не проводилось.

# Общая схема работы
![img_1](files/img/scheme1.jpg)
Дополнительная информация доступна в readme каждого компонента.

|  Сервис | Readme Url | 
| ------------- | ------------- |
| Frontend/Nuxtjs  | [Readme.md](./services/nuxtjs/README.md)  |
| Backend/DRF  | [Readme.md](./services/drf/README.md)  |

# Схема DB
![img_1](files/img/db_schema/scheme.png)

# Нагрузочные тесты

| Django drf | Fastapi |
| - | - |
| Сохраните [файл с тестами](./services/drf/tests/external/report.html) локально и откройте в браузере | Сохраните [файл с тестами](./services/fastapi/tests/external/report.html) локально и откройте в браузере |
| ![img_1](files/img/locust/django/tests.png) | ![img_1](files/img/locust/fastapi/tests.png)|
| `cd ./services/drf/` | `cd ./services/fastapi/` |


```
uv run locust -f ./tests/external/locust.py --headless -u 100 -r 10 -t 1m --html=./tests/external/report.html
```

# Доступные сервисы  

> [!IMPORTANT]
> Замените порт `1338` на тот который вы указали при настройке проекта.
> Ознакомьтесь с [дополнительной информацией](#настройки-docker)

||  Контейнер |auth| Url | Описание |
|-| ------------- | - | ------------- | - |
|__frontend__|  |  |  |  |
|| frontend | `нет` | [http://localhost:1338/](http://localhost:1338/)  | frontend на базе NuxtJs |
|__backend__|  |  |  |  |
|| fastapi  | `да` | [http://localhost:1338/fastapi/api/v1/](http://localhost:1338/fastapi/api/v1/)  | api на базе FastApi | 
|| drf | `да` | [http://localhost:1338/drf/api/v1/](http://localhost:1338/drf/api/v1/)  | api на базе DRF |
|__Документация__|  |  |  |  |
|| fastapi  | `да` | [http://localhost:1338/fastapi/docs/](http://localhost:1338/fastapi/docs/)  | Документация fastapi/api/swagger | 
|| fastapi  | `да` | [http://localhost:1338/fastapi/redoc/](http://localhost:1338/fastapi/redoc/)  | Документация fastapi/api/redoc | 
|| drf  | `да` | [http://localhost:1338/drf/sphinx/](http://localhost:1338/drf/sphinx/)  | Документация django models/views | 
|| drf  | `да` | [http://localhost:1338/drf/swagger/](http://localhost:1338/drf/swagger/)  | Документация django/api/swagger | 
||drf  | `да` | [http://localhost:1338/drf/redoc/](http://localhost:1338/drf/redoc/)  | Документация django/api/redoc | 
|__Доп. сервисы__|  |  |  |  |
|| drf | `да` | [http://localhost:1338/drf/admin/](http://localhost:1338/drf/admin/)  | Django Admin Panel |
|| adminer | `да` | [http://localhost:1338/adminer/](http://localhost:1338/adminer/)  | Web интерфейс для работы с DB |
|| jupyter | `да` | [http://localhost:1338/jupyter/](http://localhost:1338/jupyter/)  | JupyterLab |
|| smtp4dev | `да` | [http://localhost:1338/smtp4dev/](http://localhost:1338/smtp4dev/)  | SMTP сервер |
|| Apache Superset | `нет` | [http://localhost:8088/](http://localhost:8088/)  | Apache Superset |

|   |  | |
| ------------- | ------------- |  ------------- |
|![img_1](files/img/website/s1.png)  | ![img_1](files/img/website/s2.png)  | ![img_1](files/img/website/s3.png)  |
|![img_1](files/img/website/s4.png)  | ![img_1](files/img/website/s5.png)  | ![img_1](files/img/website/s6.png)  |
|![img_1](files/img/sphinx/sphinx.png)  | ![img_1](files/img/admin/admin.png)  | ![img_1](files/img/restapi/django_rest.png)  |
|![img_1](files/img/jupyter/1.png)  | ![img_1](files/img/website/s7.png)  | ![img_1](files/img/website/s8.png) |

# Установленные и настроенные модули

## Backend Django

```
dependencies = [
    "django>=6.0.1",
    "djangorestframework>=3.16.1",
    "drf-spectacular>=0.29.0",
    "gunicorn>=23.0.0",
    "psycopg2-binary>=2.9.11",
    "pylint>=4.0.4",
    "pylint-django>=2.7.0",
    "python-dotenv>=1.2.1",
    "sphinx>=9.1.0",
    "sphinx-rtd-theme>=3.1.0",
    "sphinxcontrib-django>=2.5",
]

[dependency-groups]
dev = [
    "coverage>=7.13.1",
    "django-debug-toolbar>=6.1.0",
    "django-extensions>=4.1",
    "factory-boy>=3.3.3",
    "faker>=40.1.2",
    "locust>=2.43.1",
    "pydot>=4.0.1",
    "pyparsing>=3.3.1",
    "pytest>=9.0.2",
    "pytest-django>=4.11.1",
    "ruff>=0.14.11",
]
```
Для получения дополнительной информации
```
cd services/drf/ && uv tree
```
## Backend FastApi

```
dependencies = [
    "fastapi>=0.128.0",
    "psycopg2-binary>=2.9.11",
    "pydantic>=2.12.5",
    "pylint>=4.0.4",
    "python-dotenv>=1.2.1",
    "ruff>=0.14.11",
    "sqlacodegen>=3.2.0",
    "sqlalchemy>=2.0.45",
    "uvicorn>=0.40.0",
]

[dependency-groups]
dev = [
    "eralchemy>=1.6.0",
    "graphviz>=0.21",
    "locust>=2.43.1",
]
```
Для получения дополнительной информации
```
cd services/fastapi/ && uv tree
```

## Frontend Nuxtjs
```
├── @emnapi/core@1.7.1 extraneous
├── @emnapi/runtime@1.7.1 extraneous
├── @emnapi/wasi-threads@1.1.0 extraneous
├── @iconify-json/lucide@1.2.75
├── @napi-rs/wasm-runtime@1.0.7 extraneous
├── @nuxt/icon@2.1.0
├── @nuxt/ui@4.2.1
├── @nuxtjs/tailwindcss@6.14.0
├── @tybys/wasm-util@0.10.1 extraneous
├── nuxt@4.2.1
├── typescript@5.9.3
├── vue-router@4.6.3
└── vue@3.5.25
```
Для получения дополнительной информации
```
cd services/nuxtjs/ && npm list
``` 

# Что нужно для локальной работы
Для работы над проектом вам понадобятся следующие компоненты, которые должны быть установлены локально на вашем компьютере.

| Что  | Для чего | Примечание | Версия |
| ------------- | ------------- | - | - |
| Docker Decktop  | Управление контейнерами  | Если вам не нужен UI то можете использовать `docker cli`| `4.43.1 (198352)`|
| Python3  | Для backend  | | `3.12`|
| uv  | Для backend  | | `uv 0.9.25` |
| Nodejs  | Для frontend  |  | `v25.1.0` |
| npm  | Для frontend  |  | `11.6.2` |


# Установка
> [!IMPORTANT]
> Замените `<project_name>` на название вашего проекта. Например, `test-project`

```
mkdir test-project
```
```
cd test-project/
```
Клонируйте репозиторий

Для GitHub `публичный`
```
git clone https://github.com/barmaley350/start-project.git .
```
Для GitLab `приватный`
```
git clone https://gitlab.com/barmaley350/start-project.git .
```
Для GitVerse `приватный`
```
git clone https://gitverse.ru/barmaley360/start-project.git .
```
# Настройка
## Автоматическая настройка с использованием init.sh
Самый простой способ настроить проект для работы - запусть `init.sh` скрипт который находится в корневой папке проекта.
```
chmod +x init.sh
```
```
./init.sh
```
![img_1](files/img/initsh/init_script.png)


## Настройка в ручном режиме
Для лучшего понимания, как всё работает, вы можете настроить работу в ручном режиме, настраивая каждый сервис по отдельности. Вы также можете использовать эту информацию для внесения изменений после установки и настройки с использованием `init.sh`.
### Настройки Backend/DRF
```
cd services/drf/
```
```
uv sync --dev
```
```
cp .env.example .env
```
Укажите значения для `POSTGRES_PASSWORD` и `SECRET_KEY`
```
# Укажите SECRET_KEY
SECRET_KEY='' # <--- Укажите
DEBUG=True
DJANGO_ALLOWED_HOSTS="'*'"

DATABASE_TYPE="postgresql"
POSTGRES_DB=dummy_db
POSTGRES_USER=dummy_user

# Укажите POSTGRES_PASSWORD
POSTGRES_PASSWORD="" # <--- Укажите
POSTGRES_HOST=service.db_postgres
POSTGRES_PORT=5432
```
Для создания `SECRET_KEY` можете воспользоваться следующи кодом
```
cd services/drf/
```
```
uv run python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```
Вывод команды скопируйте и вставьте в `SECRET_KEY`

### Настройки Backend/FastAPI
> [!IMPORTANT]
> `backend/fastapi` работает с той же базой данных что и `backend/drf`. 
> Это значит что параметры достура к DB должны быть одинаковые 

```
cd services/fastapi/
```
```
uv sync --dev
```
```
cp .env.example .env
```
Укажите значения для `POSTGRES_PASSWORD`
```
DATABASE_TYPE="postgresql"
POSTGRES_DB=dummy_db
POSTGRES_USER=dummy_user

# Укажите POSTGRES_PASSWORD
POSTGRES_PASSWORD="" # <--- Укажите
POSTGRES_HOST=service.db_postgres
POSTGRES_PORT=5432
```

### Настройки Frontend/NuxtJS

```
cd services/nuxtjs/
```
```
cp .env.example .env
```
```
npm install
```

### Настройки Docker
По умолчанию `nginx` стартует на порту `1338`. Если этот номер порта у вас занят, то необходимо внести изменения в `.env` файл, который расположен в корневой папке проекта предварительно скопировав содежимое `.env.example`
```
# Уникальное название для docker-compose.yaml:db-data
DB_VOLUME_NAME=

# Уникальное название для docker-compose.yaml:static-files
STATIC_VOLUME_NAME=

NGINX_PORT=1338
```
`DB_VOLUME_NAME` и `STATIC_VOLUME_NAME` - настройка данных пареметров вам может никогда не понадобится если вы используете только один проект. 

Если вы используете несколько подобных проектов то вам необходимо выбрать уникальное значение для данных параметров в рамках всех проектов. 

Это делается потому что `volumes:db-data` и `volumes:static-files` хранятся в docker контейнерах а не на локальных дисках поэтому могут быть проблемы `already in use`

Скрипт `init.sh` создает эти переменные как `$PROJECT_NAME-db-volume` и `$PROJECT_NAME-static-volume`. Вы можете сделать также.

# Первый запуск
## Запустить Docker
Первый запуск - собрать и запустить
```
docker compose up --build
```
Последующие запуски с учетом отсутствия изменения в конфигурации можно производить без `--build`.
```
docker compose up
```
## Создать django superuser
```
./run.sh 1 createsuperuser
```
## Наполнить базу тестовыми данными
```
./run.sh 1 testapp_fill_all_models --clear --count 1000
```
# Настройка git pre-commit

> [!IMPORTANT]
> Модуль `pre-commit` работает относительно текущей папки запуска git. 

В данном шаблоне структура папок организована по-другому. В целом всё работает также, просто на самописном `sh` скрипте без использования модуля `pre-commit`. Также немного изменена логика: `git commit` не пройдет, если есть любые ошибки и изменения `ruff check` и `ruff format`. 

Скопируйте файл и теперь при запуске `git commit` сначала будут запускаться `ruff check` и `ruff format` и если нет ошибок то запустится `git commit`
```
cp files/git/pre-commit .git/hooks
```
# Настройка и использование run.sh

Для более удобной работы вы можете использовать `run.sh` скрипт, который упрощает работу с повседневными задачами
```
chmod +x ./run.sh
```
```
./run.sh
```
![img_1](files/img/runsh/run_script.png)

Вы также можете добавить свои собственные команды. Для это добавьте свои команды в файл `./files/commands/run_commands.txt` используя следующий формат
```
--begin
Псевдоним
Команда
Описание что делает данная команда [необязательно]
--end
```
Например
```
--begin
ldf
cd ./services/fastapi/ && find ./app -name '*.py' | xargs uv run pylint --rcfile=.pylintrc
--end
```

# License
[MIT](LICENSE)