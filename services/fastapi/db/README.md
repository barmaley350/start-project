Устанавливаем библиотеки
```
pipenv install eralchemy graphviz
```
Создаем БД
```
pipenv run python3 ./main.py
```
Генерируем схему
```
pipenv run eralchemy -i "sqlite:///database.db" -o schema.png
```