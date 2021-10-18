---------------------------------

## Coturn TURN Server docker image  

Bring up CLI for `instrumentisto/coturn:4.5`

```bash
sudo docker run -itd --privileged=true --net=host \
--name=coturn instrumentisto/coturn:4.5 \
--user=user:pass \
--lt-cred-mech \
--realm=anydomain.com \
--listening-ip='$(detect-external-ip)' \
--external-ip='$(detect-external-ip)' \
--relay-ip='$(detect-external-ip)'
```

docker-compose configure

```bash
version: "3.8"
services:
  coturn:
	image: instrumentisto/coturn:4.5
	privileged: true
	network_mode: "host"
	restart: always
	volumes:
	  - /var:/var
	  - /tmp/turnserver.log:/tmp/turnserver.log
	  - /etc/turnserver.conf.fake:/etc/turnserver.conf
	command: docker-entrypoint.sh --user=user:pass --lt-cred-mech --realm=anydomain.com --listening-ip='$$(detect-external-ip)' --external-ip='$$(detect-external-ip)' --relay-ip='$$(detect-external-ip)'
```

