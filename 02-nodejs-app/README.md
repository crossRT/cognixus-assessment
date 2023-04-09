# How to access the nodejs application
Suggesting to use `curl`. For example:
```
IP="178.128.22.173"
curl http://$IP:31234
```

# available IPs
178.128.22.173
178.128.26.198
178.128.219.248
178.128.31.115

# Load Balance traffic
In order to see the traffic load balanced, you must now use any broswer. It's because most of the browsers sending `Connection: keep-alive` in the request header. Which will cause kubernetes not round robin the traffic to pods.
