#!/bin/bash
api_home=/srv/digichlist-api
pm2 stop $api_home/server.js --name digichlist-api
rm -fr $api_home
git clone ${REPO_API} $api_home
cd $api_home
npm install
npm audit fix
pm2 start $api_home/server.js --name digichlist-api
echo "Sehr Gut!"
