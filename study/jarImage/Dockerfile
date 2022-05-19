FROM openjdk:11 as builder
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp

RUN chmod +x ./gradlew
RUN ./gradlew clean build -x test
RUN mv build/libs/java-board-1.0-SNAPSHOT*.jar app.jar
ENTRYPOINT [ "java", "-jar", "-Dspring.profiles.active=local", "app.jar" ]
EXPOSE 8080