# Build stage
FROM docker.io/library/maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /build
COPY . .
RUN mvn package -DskipTests -Dcheckstyle.skip=true -Dmaven.gitcommitid.skip=true

# Runtime stage
FROM registry.access.redhat.com/ubi9/openjdk-21-runtime:latest
WORKDIR /deployments
COPY --from=builder /build/target/*.jar app.jar
EXPOSE 8080
ENV JAVA_OPTS=""
CMD ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
