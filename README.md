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
