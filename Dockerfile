FROM openjdk:11-jre-slim
WORKDIR /app
COPY .  /app
EXPOSE 8080
ENV SPRING_PROFILES_ACTIVE=prod
RUN apt-get update && \
    apt-get install -y maven
RUN ./mvnw clean package -DskipTests
CMD ["java", "-jar", "target/my-spring-boot-app.jar"]
