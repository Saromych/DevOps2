# DevOps2 — Dockerized pipreqs

## Что делает проект

`pipreqs` — это консольная утилита для Python-проектов. Она сканирует исходный код, анализирует все импорты и автоматически генерирует файл `requirements.txt`. В отличие от `pip freeze`, в итоговый файл попадают только реально используемые зависимости.

## Какой вариант задания выбран и почему

Выбран **Вариант 1 — «Просто работает»**.

Проект представляет собой консольное приложение без графического интерфейса. Оно идеально подходит под критерии Варианта 1: запускается одной командой, выводит результат в терминал и не требует настройки портов или сохранения состояния.

## Как запустить


# 1. Клонирование репозитория
```bash
git clone git@github.com:Saromych/DevOps2.git
cd DevOps2
```

# 2. Сборка Docker-образа
```bash
docker build -t pipreqs-app .
```

# 3. Проверка работоспособности (вывод справки)
```bash
docker run --rm pipreqs-app
```

# 4. Пример использования
```bash
mkdir test_project
echo "import os, sys, requests" > test_project/script.py
docker run --rm -v $(pwd)/test_project:/project pipreqs-app /project --print
```

# Ожидаемый вывод:
```bash
 INFO: Not scanning for jupyter notebooks.
 Requests==2.33.1
 INFO: Successfully output requirements
```
# 5. Сохранение результата в файл
```bash
docker run --rm -v $(pwd)/test_project:/project pipreqs-app /project
cat test_project/requirements.txt
```
