# ELK on Docker

This image aims to provide monitoring functionality for Hadoop Clusters.

##Build
```
docker build --rm -t elk_ubu .
```

##Run
```
# docker run -p 9200:9200 -p 3080:80 -p 5000:5000 -p 25826:25826 -i -t elk_ubu /etc/bootstrap.sh -bash
docker run -i -t --name elk_ubu --net=host elk_ubu /etc/bootstrap.sh -bash
```

#Configure dashboard
https://gist.github.com/akanto/bff27486c8ff49b5ddc0


#Generate load
stress --cpu 2 --timeout 60358
