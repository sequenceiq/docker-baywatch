# ELK on Docker

This image aims to provide monitoring functionality for Hadoop Clusters.

##Build
```
docker build --rm -t elk_ubu .
```

##Run
```
docker run -p 9200:9200  -p 3080:80 -i -t elk_ubu /etc/bootstrap.sh -bash
```

#Configure dashboard
https://gist.github.com/hbokh/33d9ff5d87e433410e77

https://gist.github.com/akanto/bff27486c8ff49b5ddc0


#Generate load
stress --cpu 2 --timeout 60
