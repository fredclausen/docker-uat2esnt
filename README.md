# docker-uat2esnt

Docker container to run ADSB Exchange's [uat2esnt](https://github.com/adsbxchange/uat2esnt). Builds and runs on `arm64`. A container is provided for, but not tested, `amd64` and `arm32v7` (see below).

This container runs a copy of uat2esnt that can be used to convert [dump978](https://github.com/flightaware/dump978)'s UAT/978 raw formatted data to a format that can be used by other ADSB containers or programs that accept the more common ADSB raw data format, such as [readsb-protobuf](https://github.com/Mictronics/readsb-protobuf/tree/dev/webapp).

## Supported tags and respective Dockerfiles

* `latest` (`master` branch, `Dockerfile`)
* `latest_nfm` (`master` branch, `Dockerfile.NFM`. See [NFM](#nfm) below)

## Multi Architecture Support

Currently, this image should pull and run on the following architectures:

* `amd64`: Linux x86-64 (Builds but is untested. If it works for you let me know!)
* `arm32v7`: ARMv7 32-bit (Odroid HC1/HC2/XU4, RPi 2/3) (Builds but is untested. If it works for you let me know!)
* `arm64`: ARMv8 64-bit (RPi 3 and 4 64-bit OSes)

## Thanks

Thanks to [mikenye](https://github.com/mikenye) for his excellent ADSB docker containers from which I shamelessly copied a lot of the ideas for setting up the docker container, as well as his excellent advice and help in getting this thing working.

## Up-and-Running with `docker run`

```shell
docker run \
 -d \
 --rm \
 --name rtlsdr-airband \
 -p 37981:37981 \
 -e DUMP978_HOST=192.168.1.100 \
fredclausen/uat2esnt
```

## Up-and-Running with Docker Compose

```yaml
version: '2.0'

services:
  uat2esnt:
    image: fredclausen/uat2esnt
    tty: true
    container_name: uat2esnt
    restart: always
    ports:
      - 37981:37981
    environment:
      - DUMP978_HOST=192.168.1.100
```

## Ports

The container will connect to a dump978 host on port `30978` and will output the data on `37981`

## Enviornment Variables

This container takes one ENV variable

* `DUMP978_HOST`

Which should be set to the hostname or IP of a dump978 host