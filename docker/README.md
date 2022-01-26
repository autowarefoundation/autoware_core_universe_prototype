# Docker images for Autoware

## Prerequisites

- [Docker](https://docs.docker.com/engine/install/ubuntu/)
- [rocker](https://github.com/osrf/rocker)

  We use `rocker` to enable GUI applications such as `rviz` and `rqt` on Docker Containers.
  Please see [here](http://wiki.ros.org/docker/Tutorials/GUI) for more details.

The setup script in this repository will install these dependencies.

## Usage

We have two types of Docker images: `development` and `prebuilt`.

The development image enables you to develop Autoware without setting up the local development environment.

The prebuilt image contains executables and enables you to try out Autoware quickly.
Please note that the prebuilt image is not designed for deployment on a real vehicle!

**Note**: Before pulling these images, please confirm and agree with the [NVIDIA Deep Learning Container license](https://developer.nvidia.com/ngc/nvidia-deep-learning-container-license).

### The development image

To use the development image image, run the following command:

```bash
docker run --rm -it -v {path_to_your_workspace}:/autoware ghcr.io/autowarefoundation/autoware-universe:latest
```

To run with `rocker`:

```bash
rocker --nvidia --x11 --user --volume {path_to_your_workspace} -- ghcr.io/autowarefoundation/autoware-universe:latest
```

If you locate your workspace under your home directory, you can use the `--home` option instead:

```bash
rocker --nvidia --x11 --user --home -- ghcr.io/autowarefoundation/autoware-universe:latest
```

To use a customized `.bashrc` for the container:

```bash
rocker --nvidia --x11 --user --home --volume $HOME/.bashrc.container:$HOME/.bashrc -- ghcr.io/autowarefoundation/autoware-universe:latest
```

### The prebuilt image

To use the prebuilt image, run the following command:

```bash
docker run --rm -it ghcr.io/autowarefoundation/autoware-universe:latest-prebuilt
```

To run with `rocker`:

```bash
rocker --nvidia --x11 --user --volume {path_to_your_workspace} -- ghcr.io/autowarefoundation/autoware-universe:latest-prebuilt
```

If you intend to use pre-existing data such as maps or Rosbags, modify the `--volume` options shown below.

```bash
rocker --nvidia --x11 --user --volume {path_to_your_workspace} --volume {path_to_your_map_data} --volume {path_to_your_log_data} -- ghcr.io/autowarefoundation/autoware-universe:latest-prebuilt
```

## Tips

### Precautions for not using `rocker`

If you run the following command, it uses the `root` permission.

```sh-session
$ docker run --rm -it -v {path_to_your_workspace}:/autoware ghcr.io/autowarefoundation/autoware-universe:latest
# colcon build
```

It means it affects

```sh-session
# exit
$ rm build/COLCON_IGNORE
rm: remove write-protected regular empty file 'build/COLCON_IGNORE'? y
rm: cannot remove 'build/COLCON_IGNORE': Permission denied
```

There are several recommended ways to prevent this.

1. Prepare a dedicated workspace for the docker image.
2. Use `rocker`.
3. Use `Visual Studio Code Remote - Containers`.

   You can use following settings. It creates a user account in a similar way as `rocker`.  
   Please see [this document](https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user) for more details.

   ```json
   // .devcontainer/devcontainer.json
   {
     "name": "Autoware",
     "build": {
       "dockerfile": "Dockerfile"
     },
     "remoteUser": "autoware",
     "settings": {
       "terminal.integrated.defaultProfile.linux": "bash"
     }
   }
   ```

   ```docker
   # .devcontainer/Dockerfile
   FROM ghcr.io/autowarefoundation/autoware-universe:latest

   ARG USERNAME=autoware
   ARG USER_UID=1000
   ARG USER_GID=$USER_UID

   RUN groupadd --gid $USER_GID $USERNAME \
     && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
     && apt-get update \
     && apt-get install -y sudo \
     && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
     && chmod 0440 /etc/sudoers.d/$USERNAME
   ```

### Using other versions of images than `latest`

There are also images versioned based on the `date` or `SemVer`.
Please use them when you need a fixed version of the image.  
The list of versions can be found [here](https://github.com/autowarefoundation/autoware/packages).

### Building Docker images on your local machine

If you build the images locally instead of pulling them from the server, run the following command:

```bash
cd autoware/
./docker/build.sh
```
