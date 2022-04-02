FROM python:3.9-slim-bullseye


RUN mkdir /code
WORKDIR /code

# Installing apps
RUN apt-get update && apt-get install -y postgresql

# Install dependencies:
COPY requirements /code/requirements/
RUN pip install -r requirements/local.txt
COPY . /code/
