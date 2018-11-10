# NextCloud Docker Pi

Creates NextCloud docker container for the Raspberry Pi as per official docker image.

The docker container can be build on x86 architecture.

## Build Container

### Register QEMU

```bash
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

### Download QEMU Static

```bash
download-qemu-static.sh
```

### Build Using Docker-Compose

```bash
docker-compose build
```
