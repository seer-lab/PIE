#Stage 1 - Install dependencies and build the app
FROM python:3.8

RUN git clone https://github.com/JetBrains/jdk8u_jdk.git
RUN git clone https://github.com/wrandelshofer/jhotdraw.git
RUN git clone https://github.com/apache/ignite.git

WORKDIR /app

COPY . .

RUN python3 -m pip install -r ./requirements.txt

ENV FLASK_APP=app/server
ENV FLASK_ENV=development
ENV MONGO_HOST host.docker.internal
EXPOSE 27017


CMD [ "python3", "-m" , "flask", "run" , "--host", "0.0.0.0"]
