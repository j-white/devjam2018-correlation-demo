# DevJam 2018 - Correlation - Demo Runbook

## Setup OpenNMS + Kafka Producer

Run OpenNMS from the `jw/oce-poc` branch.
This branch pulls in commits from a few other branches currently at to develop.

Start Kafka using Docker:
```
docker run -p 2181:2181 -p 9092:9092 --env ADVERTISED_HOST=127.0.0.1 --env ADVERTISED_PORT=9092 spotify/kafka
```

Configure the Kafka producer from the Karaf shell in OpenNMS:
```
config:edit org.opennms.features.kafka.producer.client
config:property-set bootstrap.servers 127.0.0.1:9092
config:update
```

Enable the Kafka producer:
```
feature:install opennms-kafka-producer
```

Trigger some alarm:
```
./create-node-lost-service.sh s1
```

Trigger a sync from the Karaf shell in OpenNMS:
```
kafka-producer:sync-alarms
```

## Setup OCE

See https://github.com/OpenNMS/oce

Setup a vanilla Apache Karaf 4.1.5 container.
In my case I use:

```
cd ~/labs/karaf/apache-karaf-4.1.5/
./bin/karaf clean
```

Install the feature repository:

```
feature:repo-add mvn:org.opennms.oce/oce-karaf-features/1.0.0-SNAPSHOT/xml
```

Point to OpenNMS:
```
config:edit org.opennms.oce.datasource.opennms.kafka.streams
config:property-set bootstrap.servers 127.0.0.1:9092
config:property-set commit.interval.ms 5000
config:update

config:edit org.opennms.oce.datasource.opennms
config:property-set url http://127.0.0.1:8980/opennms
config:property-set username admin
config:property-set password admin
config:update
```

Enable debug logging:
```
log:set DEBUG org.opennms.oce
```

Start the features:
```
feature:install oce-datasource-opennms oce-engine-cluster oce-driver-main
```

Tail to logs:
```
log:tail
```

## Demo

Trigger a situation

```
./alarms.sh
```

Profit
