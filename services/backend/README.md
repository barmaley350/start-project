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