# Build stage
FROM maven:3-amazoncorretto-17 as build
ADD target/words.jar words.jar 
ENTRYPOINT ["java", "-Xmx8m", "-Xms8m", "-jar", "words.jar"]
EXPOSE 8080
