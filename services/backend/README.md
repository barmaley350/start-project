# Оглавление 
Все приводимые команды выполняются в каталог `services/backend` если явно не сказано использовать другой каталог.

`<project_name>` - название корневой папки вашего проекта

- [Как посмотреть установленные модули](#как-посмотреть-установленные-модули)
- [Как создать django admin superuser](#как-создать-django-admin-superuser)
- [Как создать новое приложение django](#как-создать-новое-приложение-django)
- [Как использовать factory-boy / faker](#как-использовать-factory-boy-и-faker)
- [Как использовать shell plus](#как-использовать-shell-plus)
- [Генерация документации Sphinx](#генерация-документации-sphinx)
- [Как запускать тесты PyTest](#как-запускать-тесты-pytest)
- [Как работать с Ruff](#как-работать-с-ruff)
- [Настройка рабочего окружения для комфортной работы](#настройка-рабочего-окружения-для-комфортной-работы)



## Как посмотреть установленные модули
Посмотреть все используемые модули можно в файле `Pipfile` или выполнив команду 
```
pipenv graph
```

## Как создать django admin superuser
Для создания superuser django admin выполните комманду. `<project_name>` замените на название корневой папки вашего проекта

```
docker exec -it <project_name>-service.backend-1 pipenv run python3 manage.py createsuperuser
```

## Как создать новое приложение django
Приложения будут храниться в отдельной папке `apps` для более удобной организации структуры проекта. Перед создание приложения необходимо предварительно создать папку приложения. 

`mkdir apps/<app_name>` а затем выполнить команду

```
pipenv run python3 manage.py startapp <app_name> apps/<app_name>
```

После установки приложения необходимо изменить `name` в `apps/<app_name>/apps.py` на `apps.<app_name>`

Также не забываем добавить приложение в `settings/settings.py` в раздел `INSTALLED_APPS` в формате `apps.<apps_name>`

# Как использовать factory-boy и faker
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
Где `<project_name>` название корневой папки вашего проекта. 
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

## Как использовать shell plus
```
docker exec -it <project_name>-service.backend-1 pipenv run python3 manage.py shell_plus
```

## Генерация документации Sphinx
Документация доступна по адресу [http://localhost:1338/docs/](http://localhost:1338/docs/)


Рабочая папка в которой хранится документация - `service/backend/docs`. Для того что бы запретить произвольный доступ к документации был создан модуль `sphinx_docs` основная задача которого ограничивать доступ к документации неавторизованным пользателям. 

Для генерации документации необходимо выполнить следующие комманды. 
```
cd docs
```
```
pipenv run make html
```
Более подробная информация о Sphinx доступна на 
[официальном сайте](https://www.sphinx-doc.org/en/master/)


## Как запускать тесты PyTest
Запуск тестов происходит в контейнере
```
docker exec -it <project_name>-service.backend-1 pipenv run pytest
```

## Как работать с Ruff
### `pre-commit`и собственный велосипед
Модуль `pre-commit` работает относительно текущей папки запуска git. В данном шаблоне приложения структура папок организованна по другому. В целом все работает также просто на самописном `sh` скрипте без использования модуля `pre-commit`. Также немного изменена логика - git commit не пройдет если есть любые изменения `ruff format`. Поэтому счала `ruff fromat` а потому уже `git commit` 

Для того чтобы данный функционал разаботал необходимо выполнить комманду 
```
cp files/git/pre-commit .git/hooks
```
Настроки `ruff` находятся тут `services/backend/pyproject.toml`. По умолчанию включена проверка всего что есть. 

Запуск `ruff` в ручном режиме
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

## Настройка рабочего окружения для комфортной работы
Для быстрого доступа в контейнер и/или запуска громоздких команд вы можете использовать `commnad alias` в вашем `shell`

Например, для `zsh` можно добавить `command alias` в конфиг `.zshrc`
Имена контенеров имеют префикс названия вашей корневой папки проекта. Замените `<project_name>` на название вашей корневой папки проекта. 

Например, если вана корневая папка проекта называется `test_project` то в `zshrc` нужно добавить следующие строки: 
```
alias <command_prefix>-<command_suffix>='<command_name>'
alias <command_prefix>-<command_name>='cd /home/home/my/RepoCode/empty_dummy_project/ && docker compose up --build'
alias <command_prefix>-docker-shell='docker exec -it empty_dummy_project-service.backend-1 /bin/bash'
alias <command_prefix>-docker-shell-plus='docker exec -it empty_dummy_project-service.backend-1 pipenv run python3 manage.py shell_plus'
alias <command_prefix>-docker-pytest='docker exec -it empty_dummy_project-service.backend-1 pipenv run pytest'
alias <command_prefix>-backend-run-all='/bin/sh /home/home/my/RepoCode/empty_dummy_project/files/scripts/run_all.sh'
```
где `<command_prefix>` и `command_suffix` любые название которые вы выберите - главное что бы итоговый вариант команды не конфликтовал 
с уже существующими командами. `<project_name_path>` - абсолютный путь к коневой папке вашего проекта. `<project_name>` - название коневой папки вашего проекта. `<command_name>` - команда которую вы хотите запустить 

Например

```
alias my-project-docker-up='cd <project_name_path> && docker compose up'
alias my-project-docker-up-build='cd <project_name_path> && docker compose up --build'
alias my-project-docker-shell='docker exec -it <project_name>-service.backend-1 /bin/bash'
alias my-project-docker-shell-plus='docker exec -it <project_name>-service.backend-1 pipenv run python3 manage.py shell_plus'
alias my-project-docker-pytest='docker exec -it <project_name>-service.backend-1 pipenv run pytest'
alias my-project-backend-run-all='/bin/sh <project_name_path>/files/scripts/run_all.sh'
```

Вы также можете настроить терминал как вам удобно. Например, ubuntu terminal 

![img_1](../../files/img/terminal.png)
