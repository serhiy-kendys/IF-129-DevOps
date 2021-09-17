#!/bin/bash
ui_home=/srv/digichlist-Admin-UI
rm -fr $ui_home
git clone ${REPO_UI} $ui_home
sh /srv/scripts/ch_env_ui.sh "http://${NGINX_IP}:${API_PORT}" $ui_home/src/environments/environment.tsx
cd $ui_home
npm install
npm audit fix
npm run build
systemctl stop apache2
cp /var/www/html/.htaccess /tmp/
rm -rf /var/www/html/*
cp -r $ui_home/build/* /var/www/html/
mv /tmp/.htaccess /var/www/html/
chown -R www-data:www-data /var/www/html
systemctl start apache2
echo "Sehr Gut!"
