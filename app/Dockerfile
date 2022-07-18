#Stage 1 - Install dependencies and build the app
FROM python:3.8


WORKDIR /app

COPY . .

RUN python3 -m pip install -r ./requirements.txt

ENV FLASK_APP=app/server
ENV FLASK_ENV=development
ENV MONGO_HOST host.docker.internal
EXPOSE 27017


CMD [ "python3", "-m" , "flask", "run" , "--host", "0.0.0.0"]
