# Базовый образ Python 3.11 на Debian (нужен gcc для компиляции Cython)
FROM python:3.11-slim

# Устанавливаем системные зависимости (gcc из стандартных репозиториев)
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    make \
    build-essential \
    && rm -rf /var/lib/apt/lists/*


# Проверяем версию gcc (для уверенности)
RUN gcc --version

# Устанавливаем Python-зависимости (сначала Cython, потом остальные)
RUN pip install --no-cache-dir \
    cython==0.29.32 \
    pyyaml \
    numpy \
    jupyterlab \
    wandb \
    scikit-image \
    feret \
    pandas \
    seaborn \
    numpngw

# Устанавливаем Poetry для дополнительных зависимостей из pyproject.toml
RUN pip install poetry

WORKDIR /app

# Копируем файлы проекта
# COPY pyproject.toml poetry.lock ./

# Устанавливаем оставшиеся зависимости через Poetry (без создания venv)
#RUN poetry config virtualenvs.create false \
#    && poetry install --no-interaction --no-ansi --no-root || true

# Копируем весь исходный код
COPY . .

# Компилируем Cython модули
RUN cd VCT && make CFLAGS="-fcommon" && cd ..
ENV CFLAGS="-fcommon"
RUN python3 setup.py build_ext --inplace

# Создаем директорию для данных (Volume)
RUN mkdir /data
VOLUME /data

# Настраиваем Jupyter Lab для доступа извне
RUN jupyter lab --generate-config && \
    echo "c.ServerApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.port = 8080" >> /root/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.token = ''" >> /root/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.password = ''" >> /root/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.allow_root = True" >> /root/.jupyter/jupyter_lab_config.py

EXPOSE 8080

CMD ["jupyter", "lab", "--notebook-dir=/data", "--allow-root"]
