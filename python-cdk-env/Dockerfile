FROM python:3.9

RUN apt-get update && apt-get install openssh-server

WORKDIR /code
COPY ./requirements.txt /code
RUN pip install -r requirements.txt
