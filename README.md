# Baywatch on Docker

This image aims to provide monitoring functionality for Hadoop Clusters.

##Pull the container
```
docker pull sequenceiq/baywatch
```

##Run
```
# docker run -p 9200:9200 -p 3080:80 -p 5000:5000 -p 25826:25826 -i -t baywatch /etc/bootstrap.sh -bash
docker run -p 3080:80 -i -t baywatch /etc/bootstrap.sh -bash
```

#Configure dashboard

Hadoop metrics
https://github.com/sequenceiq/docker-baywatch/blob/master/dashboards/Hadoop%20Metrics-1412352733447.json

System resources
https://github.com/sequenceiq/docker-baywatch/blob/master/dashboards/System%20Resources-1412352757038.json

#Generate load
stress --cpu 2 --timeout 60358
