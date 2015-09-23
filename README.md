# docker-arch-freshrss

Dockerfile to build and run freshrss, image uses arch as a base

## Building the container yourself
To build this container, clone the repository and cd into it.

### Build it:
```
$ cd /repo/location/docker-arch-freshrss
$ docker build -t="freshrss" .
```

You can now use your image
```
docker run -d -v </your/storage/path/freshrss-data>:/srv/http/freshrss/data -v /etc/localtime:/etc/localtime:ro -p 8092:80 freshrss
```

