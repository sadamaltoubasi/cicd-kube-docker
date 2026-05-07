FROM maven:3.5-jdk-8-alpine AS build

WORKDIR /app
RUN apk add --no-cache git
RUN git clone https://github.com/sadamaltoubasi/cicd-kube-docker.git .
RUN mvn clean package -DskipTests

FROM tomcat:8.5-jre8-alpine

RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
