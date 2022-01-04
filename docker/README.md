# Dockerfile for Autoware

## Prerequisites

- [Docker](https://docs.docker.com/engine/install/ubuntu/)
- [rocker](https://github.com/osrf/rocker)

  We use `rocker` to enable GUI applications on Docker Containers.
  Please see [here](http://wiki.ros.org/docker/Tutorials/GUI) for more details.

The setup script in this repository will install these dependencies.

## Usage

Note: Before pulling these images, please confirm and agree with the [NVIDIA Deep Learning Container license](https://developer.nvidia.com/ngc/nvidia-deep-learning-container-license).

### Development image

This image is for developing Autoware without setting up the local development environment.

```bash
docker run --rm -it ghcr.io/autowarefoundation/autoware-universe:latest /bin/bash
```

### Prebuilt image

This image is for quickly testing Autoware's feature. Please note that it is not designed to deploy on real vehicles.

```bash
docker run --rm -it ghcr.io/autowarefoundation/autoware-universe:latest-prebuilt /bin/bash
```
