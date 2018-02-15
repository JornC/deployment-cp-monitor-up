#!/bin/bash
set -e
# ^ Fail on error

cd ~

sudo apt install maven git unzip

mkdir -p ~/gitRepos
cd ~/gitRepos
git clone git@github.com:JornC/gwt-client-common.git || true
cd gwt-client-common
git pull
mvn install

cd ..
git clone git@github.com:JornC/aerius-deploy-cp.git || true
cd aerius-deploy-cp
git pull
mvn install

sudo apt install apache2

mkdir -p ~/bin
cd ~/bin
wget -nc http://mirrors.supportex.net/apache/tomcat/tomcat-9/v9.0.4/bin/apache-tomcat-9.0.4.tar.gz
tar -xzf apache-tomcat-9.0.4.tar.gz
rm -rf tomcat
mv apache-tomcat-9.0.4 tomcat || true
rm -rf ~/bin/tomcat/webapps/*

unzip ~/gitRepos/aerius-deploy-cp/aerius-deploy-cp-wui-server/target/aerius-deploy-cp-wui-server-0.0.1-SNAPSHOT.war -d ~/bin/tomcat/webapps/ROOT

sudo a2enmod proxy proxy_ajp
sudo service apache2 restart
cd ~/deploy
cp deploycp.conf /etc/apache2/sites-available
sudo a2ensite deploycp
sudo service apache2 reload

mkdir -p ~/bin/tomcat/webapps/ROOT/WEB-INF/classes/
cp deploycp.properties ~/bin/tomcat/webapps/ROOT/WEB-INF/classes/deploycp.properties
cp logback.xml ~/bin/tomcat/webapps/ROOT/WEB-INF/classes/logback.xml

sh ~/bin/tomcat/bin/startup.sh
