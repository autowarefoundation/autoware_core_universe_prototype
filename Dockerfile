FROM ubuntu:20.04

LABEL VERSION autoware-2.0
ENV  ROS_DISTRO galactic
#
# Configure environmet
#
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#
# Install tools and libraries required by Autoware
#
# hadolint ignore=DL3008,DL3013
RUN apt-get update && apt-get install -y --no-install-recommends \
        sudo locales python3-pip 


#
# Configure environmet
#

#RUN update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX

# Add user
ENV USERNAME autoware
ARG USER_ID=1000
ARG GROUP_ID=15214

RUN groupadd --gid $GROUP_ID $USERNAME && \
        useradd --gid $GROUP_ID -m $USERNAME && \
        echo "$USERNAME:$USERNAME" | chpasswd && \
        usermod --shell /bin/bash $USERNAME && \
        usermod -aG sudo $USERNAME && \
        usermod  --uid $USER_ID $USERNAME && \
        echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
        chmod 0440 /etc/sudoers.d/$USERNAME

# Startup scripts
ENV LANG="en_US.UTF-8"
ENV PULSE_SERVER /run/pulse/native
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /etc/profile.d/ros.sh && \
    echo "export QT_X11_NO_MITSHM=1" >> /etc/profile.d/autoware.sh && \
    echo "export LANG=\"en_US.UTF-8\"" >> /etc/profile.d/autoware.sh


WORKDIR /home/$USERNAME
COPY . /home/$USERNAME
RUN  ./setup-dev-env.sh -y universe


USER $USERNAME

RUN  mkdir src && vcs import src < autoware.repos
RUN apt-get -y update && rosdep update && DEBIAN_FRONTEND=noninteractive rosdep install -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO
RUN  . /opt/ros/$ROS_DISTRO/setup.sh && colcon build --event-handlers console_cohesion+ --cmake-args -DCMAKE_BUILD_TYPE=Release


COPY ./entrypoint.sh /autoware_entrypoint.sh
# hadolint ignore=DL3002
USER root
ENTRYPOINT ["/autoware_entrypoint.sh"]