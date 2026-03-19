FROM eclipse-temurin:8-jdk-alpine

WORKDIR /app

# Copy jar file
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

# Expose port
EXPOSE 8080

# Run app
ENTRYPOINT ["java","-jar","/app/app.jar"]
