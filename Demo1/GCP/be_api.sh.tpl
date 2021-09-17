#!/bin/bash
api_home=/srv/digichlist-api
ui_home=/srv/digichlist-Admin-UI
apt update -y
apt full-upgrade -y
apt install curl -y
curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
apt install nodejs -y
apt install git -y
apt install apache2 -y
systemctl stop apache2
sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
a2enmod rewrite
git clone ${REPO_API} $api_home
cd $api_home
npm install pm2@latest -g
npm install
npm audit fix
pm2 startup
sed -i '/\/registration/,/registrationController/ s/passport/\/\/passport/' $api_home/routes/admin.routes.js
pm2 start $api_home/server.js --name digichlist-api
sleep 10 && curl --header "Content-Type: application/json" --request POST --data '{"email":"'${INI_EMAIL}'","password":"'${INI_PASSWD}'","username":"'${INI_USER}'"}' http://127.0.0.1:${API_PORT}/api/admin/registration
pm2 stop $api_home/server.js --name digichlist-api
sed -i '/registration/,/registrationController/ s/\/\/passport/passport/' $api_home/routes/admin.routes.js
pm2 start $api_home/server.js --name digichlist-api
pm2 save
git clone ${REPO_UI} $ui_home
sh /srv/scripts/ch_env_ui.sh "http://${NGINX_IP}:${API_PORT}" $ui_home/src/environments/environment.tsx
cd $ui_home
npm install
npm audit fix
npm run build
rm -rf /var/www/html/*
cp -r $ui_home/build/* /var/www/html/
mv /tmp/.htaccess /var/www/html/
chown -R www-data:www-data /var/www/html
systemctl start apache2
echo "Sehr Gut!"
