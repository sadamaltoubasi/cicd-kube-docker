FROM maven:3.5-jdk-8-alpine AS build
WORKDIR /app
RUN apk add --no-cache git
RUN git clone https://github.com/sadamaltoubasi/cicd-kube-docker.git .
RUN mvn clean package -DskipTests

FROM tomcat:8.5-jre8-alpine

# مسح التطبيقات الافتراضية
RUN rm -rf /usr/local/tomcat/webapps/*

# إنشاء مجلد ROOT وفك الـ WAR داخله أثناء الـ Build
RUN mkdir -p /usr/local/tomcat/webapps/ROOT
COPY --from=build /app/target/vprofile-v2.war /tmp/vprofile.war
RUN unzip /tmp/vprofile.war -d /usr/local/tomcat/webapps/ROOT/ && rm -f /tmp/vprofile.war

# إنشاء مجلد uploads وإعطائه الصلاحيات
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/uploads

EXPOSE 8080
CMD ["catalina.sh", "run"]