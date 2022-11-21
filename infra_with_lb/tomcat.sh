#!/bin/bash
# install the java
amazon-linux-extras epel 
amazon-linux-extras install java-openjdk11 -y
# install the tomcat
cd /opt/
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.69/bin/apache-tomcat-9.0.69.tar.gz
# extract 
tar -xvzf apache-tomcat-9.0.69.tar.gz
# delete the zip
rm -rf apache-tomcat-9.0.69.tar.gz
mv apache-tomcat* tomcat
chmod -R 755 /opt/tomcat/
sh /opt/tomcat/bin/startup.sh 