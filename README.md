# Baywatch on Docker

This image aims to provide monitoring functionality for Hadoop Clusters.

##Pull the container
```
docker pull sequenceiq/baywatch
```

##Run
To run the container with default settings:

```
docker run -d -p 3080:80 sequenceiq/baywatch
```

To use run the container with custom settings:

```
docker run -d \
    -p 3080:80 \
    -e ES_CLUSTER_NAME="es-cluster-name" \
    -e ES_DATA_PATH=/tmp \
    -e ES_WORK_PATH="/work" \
    -v /tmp:/tmp  \
    -v /data:/work \
sequenceiq/baywatch
```

To run the container in interactive mode - in both above cases (you'll be provided with a bash terminal)

```
docker run -it -p 3080:80 sequenceiq/baywatch -bash
```


#Configure dashboard

We have put together a few sample dashboard, the the list is unlimited - you can build your own dashboard based on the properties we collect.

* [Hadoop metrics](https://github.com/sequenceiq/docker-baywatch/blob/master/dashboards/Hadoop%20Metrics-1412352733447.json) dashboard


* [System resources](https://github.com/sequenceiq/docker-baywatch/blob/master/dashboards/System%20Resources-1412352757038.json) dashboard

#Generate load
stress --cpu 2 --timeout 60358
