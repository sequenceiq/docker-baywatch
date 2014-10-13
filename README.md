# Baywatch on Docker

This image aims to provide monitoring functionality for Hadoop Clusters.

##Pull the container
```
docker pull sequenceiq/baywatch
```

##Run
```
docker run -p 3080:80 -i -t baywatch /etc/bootstrap.sh -bash
```

#Configure dashboard

We have put together a few sample dashboard, the the list is unlimited - you can build your own dashboard based on the properties we collect.

* [Hadoop metrics](https://github.com/sequenceiq/docker-baywatch/blob/master/dashboards/Hadoop%20Metrics-1412352733447.json) dashboard


* [System resources](https://github.com/sequenceiq/docker-baywatch/blob/master/dashboards/System%20Resources-1412352757038.json) dashboard

#Generate load
stress --cpu 2 --timeout 60358
