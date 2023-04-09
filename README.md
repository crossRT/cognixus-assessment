# how to access

## 01-gitea
In order to access the gitea, you may use the link: https://gitea.assessment-ray.xyz

## 02-nodejs-app
In order to access the nodejs app in kubernetes cluster with load balanced traffic, you must use `curl` or browser that not sending `Connection: keep-alive` header.

For `curl`, you may use the following command
```
# IPs
IP="178.128.22.173"
#IP="178.128.26.198"
#IP="178.128.219.248"
#IP="178.128.31.115"

curl http://$IP:31234
```

## 03-docker-swarm
In order to setup this docker swarm, you must first have docker swarm mode enabled on our local machine.

```
# first build the image
docker-compose build my-app

# deploy the app
docker stack deploy -c docker-compose.yml my-app

# access to app
curl http://localhost:1234/
```

note: it's same as 02-nodejs-app. In order to see the traffic load balanced, you must not use any broswer. It's because most of the browsers sending `Connection: keep-alive` in the request header.
