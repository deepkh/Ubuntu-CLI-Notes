---------------------------------

## Example of docker-compose.yml 

For following docker image
1. Nginx
2. Gitlab
3. portainer

```bash
version: "3.8"
services:
  nginx:
    image: nginx:1.19.5
    privileged: true
    network_mode: "host"
    restart: always
    volumes:
      - _NGINX_PATH_/nginx.conf:/etc/nginx/nginx.conf
      - _NGINX_PATH_/ssl:/etc/nginx/ssl
      - _NGINX_PATH_/conf.d:/etc/nginx/conf.d
  gitlab:
    image: gitlab/gitlab-ce:13.7.0-rc3.ce.0
    ports:
      - '3000:80'
    restart: always
    volumes:
      - _GITLAB_HOME_/config:/etc/gitlab
      - _GITLAB_HOME_/logs:/var/log/gitlab
      - _GITLAB_HOME_/data:/var/opt/gitlab
  portainer:
    image: portainer/portainer-ce:2.0.0
    ports:
      - '9000:9000'
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - _PORTAINER_PATH_:/data
```

bring up command

```bash
sudo cat docker-compose.yml.template | \
sed "s@_NGINX_PATH_@${NGINX_PATH}@g" |\
sed "s@_GITLAB_HOME_@${GITLAB_HOME}@g" |\
sed "s@_PORTAINER_PATH_@${PORTAINER_PATH}@g" \
> /tmp/docker-compose.yml
sudo docker-compose -f /tmp/docker-compose.yml up -d
```

The above docker-compose.yml would be equal to

```bash
#!/bin/bash
_gitlab_run() {
  sudo docker run -itd \
  -p 3001:3001 \
  --name gitlab \
  --restart always \
  --volume $GITLAB_HOME/config:/etc/gitlab \
  --volume $GITLAB_HOME/logs:/var/log/gitlab \
  --volume $GITLAB_HOME/data:/var/opt/gitlab \
  gitlab/gitlab-ce:13.7.0-rc3.ce.0
}

_portainer_run() {
  sudo docker run -itd \
  -p 9000:9000 \
  --name=portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ${PORTAINER_PATH}:/data \
  portainer/portainer-ce:2.0.0
}

_nginx_run() {
  sudo docker run -itd \
  --privileged=true \
  --net=host \
  --name nginx \
  --restart always \
  -v ${NGINX_PATH}/nginx.conf:/etc/nginx/nginx.conf \
  -v ${NGINX_PATH}/ssl:/etc/nginx/ssl \
  -v ${NGINX_PATH}/conf.d:/etc/nginx/conf.d \
  nginx:1.19.5
}

_nginx_run
_gitlab_run
_portainer_run
```





