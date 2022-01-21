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

You can use this image as below.
If you do not mount your workspace by `-v` option, the workspace used for building `prebuilt` image is opened, but it is usually useless.

```bash
docker run --rm -it -v {path_to_your_workspace}:/autoware ghcr.io/autowarefoundation/autoware-universe:latest
```

It is useful to use `rocker` if you launch `rviz` or other GUI applications.
Please note that `setup.bash` is not automatically sourced with `rocker`.

```bash
rocker --nvidia --x11 --user --volume {path_to_your_workspace} -- ghcr.io/autowarefoundation/autoware-universe:latest
```

It is also useful to use `--home` option instead of specifying each `--volume`.
Please note that you should not write settings that depend on your local machine, which causes errors.

```bash
rocker --nvidia --x11 --user --home -- ghcr.io/autowarefoundation/autoware-universe:latest
```

### Prebuilt image

This image is for quickly testing Autoware's feature. Please note that it is not designed to deploy on real vehicles.

You can use this image as below.

```bash
docker run --rm -it ghcr.io/autowarefoundation/autoware-universe:latest-prebuilt
```

If you use `rocker`:

```bash
rocker --nvidia --x11 --user --volume {path_to_your_workspace} -- ghcr.io/autowarefoundation/autoware-universe:latest-prebuilt
```

If you use some map data and log data, add `--volume` options as below or use `--home` option and place the data under your home directory.

```bash
rocker --nvidia --x11 --user --volume {path_to_your_workspace} --volume {path_to_your_map_data} --volume {path_to_your_log_data} -- ghcr.io/autowarefoundation/autoware-universe:latest-prebuilt
```
