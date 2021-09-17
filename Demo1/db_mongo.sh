#!/bin/bash
apt update -y
apt full-upgrade -y
apt install gnupg wget -y
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -
echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/5.0 main" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list
apt update -y
apt install mongodb-org -y
systemctl daemon-reload
systemctl enable mongod
systemctl stop mongod
sed -i "s/bindIp\: 127.0.0.1/bindIpAll\: true/" /etc/mongod.conf
systemctl start mongod
#sleep 10 && mongo 127.0.0.1/app --eval 'var document = { email : $(cat /tmp/ini_email), password : $(cat /tmp/ini_passwd), username : $(cat /tmp/ini_user), "__v" : 0 }; db.admins.insert(document);'
echo "Sehr Gut!"
