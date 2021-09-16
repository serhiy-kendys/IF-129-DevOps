#!/bin/bash
echo "NODE_ENV="${NODE_ENV} >> /etc/environment
echo "PORT="${API_PORT} >> /etc/environment
echo "MONGO_URI=mongodb://"${MONGODB_IP}":27017/app" >> /etc/environment
echo "JWT="${JWT} >> /etc/environment
