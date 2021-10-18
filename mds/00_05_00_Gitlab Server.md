---------------------------------

## Gitlab on Docker Engine
### General

Export  `GITLAB_HOME` system variable

```bash
export GITLAB_HOME=/opt/gitlab
```

Pull offical gitlab docker image

```bash
sudo docker pull gitlab/gitlab-ce:13.7.0-rc3.ce.0
```

Run the gitlab container

```bash
sudo docker run -itd \
--hostname yourname \
-p 443:443 \
--name gitlab \
--restart always \
--volume $GITLAB_HOME/config:/etc/gitlab \
--volume $GITLAB_HOME/logs:/var/log/gitlab \
--volume $GITLAB_HOME/data:/var/opt/gitlab \
gitlab/gitlab-ce:13.7.0-rc3.ce.0
```

"--restart always" is means auto start the container after docker engine was boot-up. 

---------------------------------

### Enter the gitlab conatiner and modify the custom configure

Login into the gitlab container 

```bash
sudo docker exec -it gitlab /bin/bash
```

Edit /etc/gitlab/gitlab.rb to make you custom settings.

```bash
vim /etc/gitlab/gitlab.rb
```

reload configure

```bash
gitlab-ctl reconfigure
```

quit the gitlab container

```bash
Ctrl +P, Ctrl + Q
```

---------------------------------

### Configure for standalone gitlab server

Copy the custom cert and key 

```bash
sudo mkdir -p /etc/gitlab/config/ssl
sudo chmod 755 /etc/gitlab/config/ssl
sudo cp yourname.crt /etc/gitlab/config/ssl/
sudo cp yourname.key /etc/gitlab/config/ssl/
```

Edit the `/etc/gitlab/gitlab.rb` and then

```bash
external_url 'https://yourdomain.com'
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/ssl/yourname.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/yourname.key"
```

---------------------------------

### Configure for gitlab server behind the reverse proxy

The settings is means that expose 80 port to reverse proxy, but gitlab still redirect URL to 'https://yourdomain.com'

Ref: [https://docs.gitlab.com/omnibus/settings/nginx.html#supporting-proxied-ssl]

Edit the `/etc/gitlab/gitlab.rb` 

```bash
external_url 'https://yourdomain.com'
nginx['redirect_http_to_https'] = false
nginx['listen_port'] = 80
nginx['listen_https'] = false
```

---------------------------------

### References

* [Gitlab-CE dokcer image](https://hub.docker.com/r/gitlab/gitlab-ce/tags?page=1&ordering=last_updated)
* [Install GitLab using Docker Engine](https://docs.gitlab.com/omnibus/docker/#install-gitlab-using-docker-engine)
* [Manually configuring HTTPS](https://docs.gitlab.com/omnibus/settings/nginx.html#manually-configuring-https)
* [Add iptables policies before Docker’s rules](https://docs.docker.com/network/iptables/#add-iptables-policies-before-dockers-rules)

