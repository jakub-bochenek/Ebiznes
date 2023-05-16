FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y -q software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y unzip && \
    apt-get install -y -q python3.8 && \
    apt-get install -y -q openjdk-8-jdk && \
    apt-get install -y -q wget && \
    apt-get clean;
# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Instalacja najnowszej wersji Gradle
RUN wget https://services.gradle.org/distributions/gradle-7.1.1-bin.zip \
    && unzip -d /opt/gradle gradle-7.1.1-bin.zip \
    && rm gradle-7.1.1-bin.zip
ENV GRADLE_HOME=/opt/gradle/gradle-7.1.1
ENV PATH=$PATH:$GRADLE_HOME/bin

RUN apt-get update && apt-get install -y sqlite3 libsqlite3-dev

WORKDIR /gradleProject

RUN gradle init --type java-application
RUN echo 'dependencies { compile group: "org.xerial", name: "sqlite-jdbc", version: "3.34.0" }' >> build.gradle
CMD ["gradle", "run"]

