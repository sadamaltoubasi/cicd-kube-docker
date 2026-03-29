# المرحلة الأولى: بناء التطبيق (Build Stage)
FROM eclipse-temurin:17-jdk AS BUILD_IMAGE
RUN apt-get update && apt-get install -y git maven
RUN git clone https://github.com/sadamaltoubasi/cicd-kube-docker.git
# الانتقال للمجلد الصحيح وبناء الملف
RUN cd cicd-kube-docker && mvn install

# المرحلة الثانية: التشغيل (Runtime Stage)
FROM tomcat:9.0-jdk17-openjdk

RUN rm -rf /usr/local/tomcat/webapps/*

# نسخ ملف الـ war الناتج من المرحلة الأولى
COPY --from=BUILD_IMAGE cicd-kube-docker/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

# إضافة التصاريح اللازمة لـ Java 17 للتعامل مع Reflection في النسخ القديمة من Spring
# أضفنا المزيد من الـ opens لتجنب الانهيار (Crash)
ENV JAVA_OPTS="-Djava.awt.headless=true \
               --add-opens java.base/java.lang.invoke=ALL-UNNAMED \
               --add-opens java.base/java.lang=ALL-UNNAMED \
               --add-opens java.base/java.util=ALL-UNNAMED"

EXPOSE 8080
CMD ["catalina.sh", "run"]