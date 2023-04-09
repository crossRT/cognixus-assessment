# Build image
```
docker-compose build my-app
```

# Run the app on docker swarm
```
docker stack deploy -c docker-compose.yml my-app
```

# How to access the app
```
curl http://localhost:1234/
```

# Load Balance traffic
In order to see the traffic load balanced, you must now use any broswer. It's because most of the browsers sending `Connection: keep-alive` in the request header.
