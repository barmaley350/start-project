Устанавливаем библиотеки
```
uv install eralchemy graphviz
```
Создаем БД
```
uv run python3 ./main.py
```
Генерируем схему
```
uv run eralchemy -i "sqlite:///database.db" -o schema.png
```