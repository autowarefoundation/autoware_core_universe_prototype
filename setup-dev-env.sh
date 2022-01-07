#!/usr/bin/env bash
# Setup development environment for Autoware Core/Universe.
# Usage: setup-dev-env.sh <installation_type('core' or 'universe')>

set -e

SCRIPT_DIR=$(readlink -f "$(dirname "$0")")

# Parse arguments
args=()
while [ "$1" != "" ]; do
    case "$1" in
    -y)
        option_yes=true
        ;;
    -v)
        option_verbose=true
        ;;
    *)
        args+=("$1")
        ;;
    esac
    shift
done

# Select installation type
core_universe=universe # default

if [ ${#args[@]} -ge 1 ]; then
    core_universe=${args[0]}
fi

if [ "$core_universe" != "core" ] && [ "$core_universe" != "universe" ]; then
    echo -e "\e[31mPlease input a valid installation type 'core' or 'universe' as the 1st argument, or keep it empty to use the default.\e[m"
    exit 1
fi

# Confirm to start installation
ansible_options=()
if [ "$option_yes" = "true" ]; then
    echo -e "\e[36mRun setup in non-interactive mode.\e[m"
    ansible_options+=("--extra-vars" "install_nvidia=y")
else
    echo -e "\e[33mSetting up the build environment take up to 1 hour.\e[m"
    read -rp ">  Are you sure to run setup? [y/N] " answer

    # Check whether to cancel
    if ! [[ ${answer:0:1} =~ y|Y ]]; then
        echo -e "\e[33mCancelled.\e[0m"
        exit 1
    fi
fi

# Check verbose option
if [ "$option_verbose" = "true" ]; then
    ansible_options+=("-v")
fi

# Check sudo
if ! (command -v sudo >/dev/null 2>&1); then
    SUDO=
else
    SUDO=sudo
    ansible_options+=("--ask-become-pass")
fi

# Install pip for ansible
if ! (command -v pip3 >/dev/null 2>&1); then
    $SUDO apt-get -y update
    $SUDO apt-get -y install python3-pip
fi

# Install ansible
ansible_version=$(pip3 list | grep -oP "^ansible\s+\K([0-9]+)" || true)
if [ "$ansible_version" != "5" ]; then
    $SUDO pip3 install -U "ansible==5.*"
fi

# Install ansible collections
ansible-galaxy collection install -f -r "$SCRIPT_DIR/ansible-galaxy-requirements.yaml"

# Run ansible
echo Run ansible-playbook "autoware.dev_env.$core_universe" "${ansible_options[@]}"
if ansible-playbook "autoware.dev_env.$core_universe" "${ansible_options[@]}"; then
    echo -e "\e[32mCompleted.\e[0m"
    exit 0
else
    echo -e "\e[31mFailed.\e[0m"
    exit 1
fi
