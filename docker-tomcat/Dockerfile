FROM tomcat:9.0-jdk8-openjdk
RUN rm -rf /usr/local/tomcat/webapps/*
RUN mkdir -p /usr/local/tomcat/webapps/ROOT &&     echo "<h1>Tomcat Deployed via Docker!</h1>" > /usr/local/tomcat/webapps/ROOT/index.html
EXPOSE 8080
CMD ["catalina.sh", "run"]
