# docker-health-checker
To check CPU, RAM and HDD of the docker host.

## Utilization

### Run
```
docker run -d --name hc jngermon/docker-health-checker
```

### Use
```
docker exec hc utilization -h
```

### Examples
```
docker exec hc utilization cpu
docker exec hc utilization ram
docker exec hc utilization hdd
```
