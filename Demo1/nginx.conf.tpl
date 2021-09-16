user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
	worker_connections 768;
	# multi_accept on;
}

http {
  upstream digichlist-Admin-UI {
    ip_hash;
    server ${NODE0} max_fails=3 fail_timeout=600s;
    server ${NODE1} max_fails=3 fail_timeout=600s;
  }

  server {
    listen 80;
    location / {
      proxy_pass http://digichlist-Admin-UI;
    }
  }
  upstream digichlist-api {
    ip_hash;
    server ${NODE0}:${PORT} max_fails=3 fail_timeout=600s;
    server ${NODE1}:${PORT} max_fails=3 fail_timeout=600s;
  }

  server {
    listen ${PORT};
    location / {
      proxy_pass http://digichlist-api;
#       proxy_set_header   X-Real-IP $remote_addr;
#       proxy_set_header   Host      $http_host;
    }
  }
}
