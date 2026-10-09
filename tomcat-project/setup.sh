#!/bin/bash
set -e

echo " 1. Updating System Packages "
sudo apt-get update -y

echo " 2. Installing OpenJDK 8 & Nginx "
sudo apt-get install -y openjdk-8-jdk nginx wget tar

echo " 3. Downloading and Extracting Apache Tomcat 9 "
TOMCAT_VER="9.0.86"
wget -q https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VER}/bin/apache-tomcat-${TOMCAT_VER}.tar.gz -O /tmp/tomcat.tar.gz

sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat || true
sudo mkdir -p /opt/tomcat
sudo tar -xf /tmp/tomcat.tar.gz -C /opt/tomcat --strip-components=1

sudo chown -R tomcat:tomcat /opt/tomcat
sudo chmod -R g+r /opt/tomcat/conf
sudo chmod -R g+x /opt/tomcat/conf

echo " 4. Changing Tomcat Default Port to 7070 "
sudo sed -i 's/port="8080"/port="7070"/g' /opt/tomcat/conf/server.xml

echo " 5. Creating Systemd Service for Tomcat  "
cat <<EOT | sudo tee /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat 9 Web Application Server
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_BASE=/opt/tomcat"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOT

sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat

echo " 6. Configuring Nginx Reverse Proxy (Port 80 -> Port 7070) "
cat <<EOT | sudo tee /etc/nginx/sites-available/tomcat
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:7070/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOT

sudo ln -sf /etc/nginx/sites-available/tomcat /etc/nginx/sites-enabled/default
sudo systemctl restart nginx

echo "Setup Completed Successfully! "
