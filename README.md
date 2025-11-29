# Известные проблемы
## `pre-commit`и собственный велосипед
Модуль `pre-commit` работает относительно текущей папки запуска git. В данном шаблоне приложения структура папок организованна по другому. В целом все работает также просто на самописном `sh` скрипте без использования модуля `pre-commit`. Также немного изменена логика - git commit не пройдет если есть любые изменения `ruff format`. Поэтому счала `ruff fromat` а потому уже `git commit` 

Подробнее тут `files/git/pre-commit`

# Roadmap
## Перейти с `pipenv` на `uv`
В `pipenv` есть возможность хранить окружение за пределами рабочей паки проекта. Это позволяет чистить диск простым удалением всех окружений из одной папки. Для восстановления окружения достаточно выполнить `pipenv sync --dev`.

 Это пока единственная причина почему еще не `uv`

## Перейти с django/drf на FastAPI
Это тестовый проект. Хочется пощупать всё. В перспективе просто добавится +1 микросервис а уж подключать его или нет это дело каждого.

# Описание
Сборка для быстрого старта разработки нового проекта. Данная сборка включает в себя следующие компоненты 

![img_1](files/img/scheme1.jpg)

По умолчанию установлены и настроены следующие модули для backend и frontend

## backend/django
```
django-debug-toolbar==6.1.0
├── django [required: >=4.2.9, installed: 5.2.8]
│   ├── asgiref [required: >=3.8.1, installed: 3.11.0]
│   └── sqlparse [required: >=0.3.1, installed: 0.5.4]
└── sqlparse [required: >=0.2, installed: 0.5.4]
django-extensions==4.1
└── django [required: >=4.2, installed: 5.2.8]
    ├── asgiref [required: >=3.8.1, installed: 3.11.0]
    └── sqlparse [required: >=0.3.1, installed: 0.5.4]
djangorestframework==3.16.1
└── django [required: >=4.2, installed: 5.2.8]
    ├── asgiref [required: >=3.8.1, installed: 3.11.0]
    └── sqlparse [required: >=0.3.1, installed: 0.5.4]
factory-boy==3.3.3
└── faker [required: >=0.7.0, installed: 38.2.0]
    └── tzdata [required: Any, installed: 2025.2]
gunicorn==23.0.0
└── packaging [required: Any, installed: 25.0]
psycopg2-binary==2.9.11
python-dotenv==1.2.1
ruff==0.14.7

```

## frontend/nuxtjs
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

`frontend/nuxtjs` доступен `http://localhost:1338/`

`backend/django` доступен `http://localhost:1338/admin/`

`adminer` постоянного порта не имеет, для того чтобы избежать возможных конфликтов с уже установленными контейнерами

Получить адрес `adminer` можно либо через Docker Desktop, либо через CLI.
```
docker inspect --format='                                                                                        
{{range $p, $conf := .NetworkSettings.Ports}}
  http://localhost:{{(index $conf 0).HostPort}}
{{end}}' <root_project_folder>-service.adminer-1
```
Где `<root_project_folder>` — название корневой папки вашего проекта. Например, если название корневой папки вашего проекта `my_project`, то полное имя контейнера будет иметь вид `my_project-service.adminer-1`


Вывод
```
http://localhost:45925
```

# Структура каталогов
```
./<project_name>
./<project_name>/start.py
./<project_name>/readme_files
./<project_name>/readme_files/scheme1.jpg
./<project_name>/start.sh
./<project_name>/services
./<project_name>/services/frontend
./<project_name>/services/frontend/Dockerfile
./<project_name>/services/frontend/node_modules
./<project_name>/services/frontend/tsconfig.json
./<project_name>/services/frontend/.env.example
./<project_name>/services/frontend/nuxt.config.ts
./<project_name>/services/frontend/README.md
./<project_name>/services/frontend/package-lock.json
./<project_name>/services/frontend/.nuxt
./<project_name>/services/frontend/app
./<project_name>/services/frontend/app/app.vue
./<project_name>/services/frontend/.env
./<project_name>/services/frontend/package.json
./<project_name>/services/frontend/public
./<project_name>/services/frontend/public/favicon.ico
./<project_name>/services/frontend/public/robots.txt
./<project_name>/services/frontend/.gitignore
./<project_name>/services/nginx
./<project_name>/services/nginx/Dockerfile
./<project_name>/services/nginx/nginx.conf
./<project_name>/services/backend
./<project_name>/services/backend/Dockerfile
./<project_name>/services/backend/Pipfile
./<project_name>/services/backend/gunicorn.py
./<project_name>/services/backend/.env.example
./<project_name>/services/backend/run_before.sh
./<project_name>/services/backend/README.md
./<project_name>/services/backend/Pipfile.lock
./<project_name>/services/backend/settings
./<project_name>/services/backend/settings/urls.py
./<project_name>/services/backend/settings/settings.py
./<project_name>/services/backend/settings/wsgi.py
./<project_name>/services/backend/settings/__init__.py
./<project_name>/services/backend/settings/asgi.py
./<project_name>/services/backend/apps
./<project_name>/services/backend/apps/<project_name>
./<project_name>/services/backend/apps/<project_name>/views.py
./<project_name>/services/backend/apps/<project_name>/tests.py
./<project_name>/services/backend/apps/<project_name>/models.py
./<project_name>/services/backend/apps/<project_name>/migrations
./<project_name>/services/backend/apps/<project_name>/migrations/__init__.py
./<project_name>/services/backend/apps/<project_name>/apps.py
./<project_name>/services/backend/apps/<project_name>/__init__.py
./<project_name>/services/backend/apps/<project_name>/admin.py
./<project_name>/services/backend/apps/__init__.py
./<project_name>/services/backend/.env
./<project_name>/services/backend/run_before.py
./<project_name>/services/backend/.gitignore
./<project_name>/services/backend/manage.py
./<project_name>/services/backend/static
./<project_name>/services/postgres
./<project_name>/services/postgres/db
./<project_name>/services/postgres/.gitignore
./<project_name>/README.md
./<project_name>/docker-compose.yaml
./<project_name>/.git
./<project_name>/.gitignore


```
# Установка и настройка
Если имеется уже запущенный пробный проект, то необходимо изменить входящий порт `nginx`. Для того чтобы это сделать, необходимо отредактировать файл `docker-compose.yaml`. Внесите изменения в секцию `ports` 

```
service.nginx:
    build:
      context: .
      dockerfile: ./services/nginx/Dockerfile
    ports:
      - 1338:80 # Измените 1338 на любой другой свободный локальный порт. Например, 1340
    depends_on:
      - service.frontend
    volumes:
      - static_volume:/usr/share/nginx/html/static
    restart: unless-stopped
    networks:
      - internal-net
```



Первый запуск - собрать и запустить
```
docker compose up --build
```

Для создания superuser django admin выполните комманду ниже где `<project_name>` название вашей коневой папки проекта

```
docker exec -it <project_name>-service.backend-1 pipenv run python3 manage.py createsuperuser
```

Для локальной работы с проектом (добавление/удаление модулей) вам понадобятся:

## backend/django
1. python3 
2. pipenv

## frontend/nuxtjs
1. nodejs
2. npm