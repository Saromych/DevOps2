# Используем специализированный образ python (не ubuntu)
FROM python:3.11-slim

WORKDIR /app

# Копируем файлы проекта
COPY . .

# Устанавливаем pipreqs и его зависимости
RUN pip install --no-cache-dir .

# Точка входа — команда pipreqs
ENTRYPOINT ["pipreqs"]

# По умолчанию показываем справку
CMD ["--help"]

