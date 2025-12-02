# Установленные модули
```
[packages]
django = "*"
djangorestframework = "*"
gunicorn = "*"
python-dotenv = "*"
psycopg2-binary = "*"
sphinx = "*"
sphinx-rtd-theme = "*"
sphinxcontrib-django = "*"

[dev-packages]
django-debug-toolbar = "*"
ruff = "*"
django-extensions = "*"
factory-boy = "*"
faker = "*"
pytest = "*"
pytest-django = "*"
coverage = "*"
```
# Создание django admin superuser
Для создания superuser django admin выполните комманду ниже где `<project_name>` название вашей коневой папки проекта

```
docker exec -it <project_name>-service.backend-1 pipenv run python3 manage.py createsuperuser
```

# Создание приложений
Приложения будут храниться в отдельной папке `apps` для более удобной организации структуры проекта. Перед создание приложения необходимо предварительно создать папку приложения. 

`mkdir apps/<app_name>` а затем выполнить

```
pipenv run python3 manage.py startapp <app_name> apps/<app_name>
```

После установки приложения необходимо изменить `name` в `apps/<app_name>/apps.py` на `apps.<app_name>`

Также не забываем добавить приложение в `settings/settings.py` в раздел `INSTALLED_APPS` в формате `apps.<apps_name>`

# Работа в Docker контейнере
### django_extensions / shell_plus
```
docker exec -it <project_name>-service.backend-1 pipenv run python3 manage.py shell_plus
```

`<project_name>` название папки корневого проекта. Также название контейнера можно посмотреть в Docker Desktop

# Генерация документации Sphinx
Рабочая папка в котрой храниться документация `service/backend/docs`. Для того что бы запретить произвольный доступ к документации был создан модуль `sphinx_docs` основная задача которого ограничивать доступ. 

Для генерации документации необходимо выполнить следующие комманды. Документация доступна по адресу `http://localhost:1338/docs/` 
```
cd services/backend/docs
pipenv run make html
```
В остальном читайте документацию

# PyTest
## Структура каталогов
```
% find ./tests 
./tests
./tests/unit
./tests/unit/testapp
./tests/unit/testapp/conftest.py
./tests/unit/testapp/__init__.py
./tests/unit/testapp/models
./tests/unit/testapp/models/__init__.py
./tests/unit/testapp/models/test_project_models.py
./tests/unit/conftest.py
./tests/unit/__init__.py
./tests/integration
./tests/integration/conftest.py
./tests/integration/__init__.py
./tests/conftest.py
./tests/e2e
./tests/e2e/conftest.py
./tests/e2e/__init__.py
./tests/__init__.py
```
## Запуск тестов
Запуск тестов происходит в контейнере
```
docker exec -it empty_dummy_project-service.backend-1 pipenv run pytest
```
Где `empty_dummy_project` название вашей корневой папки проекта имя которой участвует в формировании имени контейнера.

Для дополнительного удобства вы можете содать `command alias` в настройках вашего терминала для более быстрого запуска

# ruff
## `pre-commit`и собственный велосипед
Модуль `pre-commit` работает относительно текущей папки запуска git. В данном шаблоне приложения структура папок организованна по другому. В целом все работает также просто на самописном `sh` скрипте без использования модуля `pre-commit`. Также немного изменена логика - git commit не пройдет если есть любые изменения `ruff format`. Поэтому счала `ruff fromat` а потому уже `git commit` 


Для того чтобы данный функционал разаботал необходимо выполнить комманду 
```
cp files/git/pre-commet .git/hooks
```

Подробнее тут `files/git/pre-commit`

Настроки `ruff` находятся тут `services/backend/pyproject.toml`. По умолчанию включена проверка всего что есть. 

Запуск `ruff` в ручном режиме (находясь в папке `services/backend`)
```
pipenv run ruff check
``` 
```
pipenv run ruff format
```
или для проверки без изменений
```
pipenv run ruff format --check --diff
```

# factory-boy / faker
В проекте по умолчанию создано приложение `apps/testapp` с одной моделью `Projects`. 
Наполнить модель данными можно через `shell_plus`
который уже установлен и минимально настроен в файле `settings/setting.py` для использования `apps/testapp/factories.py`. 
```
# shell_plus settings
SHELL_PLUS_IMPORTS = [
    "from apps.testapp.factories import *",  # Imports all factories from factories.py
]
```
Работа с shell_plus происходит в рамках контейнера.
```
docker exec -it <project_name>-service.backend-1 pipenv run python3 manage.py shell_plus
```
Где `<project_name>` название корневой папки вашего проекта. Например, если коневая папка называется `empty_dummy_project` то команда будет выглядеть так 
```
docker exec -it empty_dummy_project-service.backend-1 pipenv run python3 manage.py shell_plus
```
После успешного выполенения команды можем наполнить модель `Project` из `apps/testapp/models.py` произвольными данными
```
>>> ProjectFactory.create_batch(100)
>>> Project.objects.count()
100
>>> p = Project.objects.get(pk=1)
>>> p.title
'Падаль правильный проход потом устройство. Коллектив ведь находить медицина вряд.'
>>> p.description
'Пропаганда эффект космос доставать. Хозяйка спорт сутки ночь багровый мальчишка. Издали терапия остановить.\nЛететь адвокат тусклый аж наступать сверкать провал витрина. Трубка солнце что изображать сынок очко направо. Мгновение стакан тусклый инфекция сомнительный успокоиться.\nБлин совещание правильный слишком. Сомнительный правление спасть. Непривычный потом страсть нож конференция валюта выкинуть.'
>>> 
```
# Настройка окружения для комфортной работы
Для быстрого доступа в контейнер вы можете использовать `commnad alias` в вашем `shell`

Например, для `zsh` можно добавить `command alias` в конфиг `.zshrc`
Имена контенеров имеют префикс названия вашей корневой папки проекта. Замените `<project_name>` на название вашей корневой папки проекта. Например, если вана коневая папка проекта называется `empty_dummy_project` то в `zshrc` нужно добавить следующие строки: 
1. `dummy-docker-shell` - запуск пустого shell в контейнере
2. `dummy-docker-shell-plus` - запуск shell_plus
3. `dummy-docker-pytest` - запуск pytest

```
alias dummy-docker-up='cd /home/home/my/RepoCode/empty_dummy_project/ && docker compose up'
alias dummy-docker-up-build='cd /home/home/my/RepoCode/empty_dummy_project/ && docker compose up --build'
alias dummy-docker-shell='docker exec -it empty_dummy_project-service.backend-1 /bin/bash'
alias dummy-docker-shell-plus='docker exec -it empty_dummy_project-service.backend-1 pipenv run python3 manage.py shell_plus'
alias dummy-docker-pytest='docker exec -it empty_dummy_project-service.backend-1 pipenv run pytest'
alias dummy-backend-run-all='/bin/sh /home/home/my/RepoCode/empty_dummy_project/files/scripts/run_all.sh'
```
Вы также можете настроить терминал как вам удобно. Например, ubuntu terminal 

![img_1](../../files/img/terminal.png)