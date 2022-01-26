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

To use the development image, run the following command:

```bash
docker run --rm -it -v {path_to_your_workspace}:/autoware ghcr.io/autowarefoundation/autoware-universe:latest
```

To use the development image with `rocker` in order to run `rviz` or any other GUI applications, run the following command:
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

Please note that the prebuilt Autoware Docker image is not designed for deployment on a real vehicle!

To use the prebuilt image, run the following command:

```bash
docker run --rm -it ghcr.io/autowarefoundation/autoware-universe:latest-prebuilt
```

To use the prebuilt image with `rocker`:

```bash
rocker --nvidia --x11 --user --volume {path_to_your_workspace} -- ghcr.io/autowarefoundation/autoware-universe:latest-prebuilt
```

If you intend to use pre-existing data such as maps or Rosbags, either modify the `--volume` options shown below or alternatively replace them with the `--home` option and place the required data under your home directory.

```bash
rocker --nvidia --x11 --user --volume {path_to_your_workspace} --volume {path_to_your_map_data} --volume {path_to_your_log_data} -- ghcr.io/autowarefoundation/autoware-universe:latest-prebuilt
```
