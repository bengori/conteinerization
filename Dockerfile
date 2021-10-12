# syntax=docker/dockerfile:1

# установка базового образа
FROM python:3.8

# подготовка системы
RUN apt-get update -y && apt-get install -y

# создание пользователя для  контейнера без прав root 
RUN groupadd --gid 5000 myuser && useradd --home-dir /home/myuser --create-home --uid 5000 --gid 5000 --shell /bin/sh --skel /dev/null myuser

# установка рабочей директории в контейнере
WORKDIR /home/myuser

ENV PATH $PATH:/home/myuser/.local/bin

USER myuser

# копирование файла зависимостей requirements.txt в рабочую директорию
COPY requirements.txt /home/myuser

# установка зависимостей
RUN python3 -m pip install --upgrade pip
RUN pip install --user -r requirements.txt

# копирование приложения app.py в рабочую диреккторию
COPY app.py /home/myuser 

# обозначение необходимых портов
EXPOSE 8080

# добавление переменных окружения
ENV DOCKER_CONTENT_TRUST = 1
ENV APP_TMP_DATA=/tmp

# команда при запуске контейнера
ENTRYPOINT python3 app.py runserver 0.0.0.0:8000
