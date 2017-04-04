# Debian-OpenCV3

This docker image provides latest stable Debian, with Python 2.7/3.4 and OpenCV 3.2.
It also has version for RaspberryPi 3, see corresponding branch.

# Installing Docker

## Ubuntu

    sudo apt install docker.io
    sudo usermod -aG docker $(whoami)

Until you re-login, you will have to prefix all `docker` commands with `sudo`.

## Windows

Download "Docker Toolbox" from https://www.docker.com/products/docker-toolbox, install it,
run "Docker Quick-start Terminal", and let it do its magic.

You can also try "Docker for Windows", which sounds like a better option, but is unsupported on my Windows machine.

# Building

    docker build -t al42and/debian-opencv3 --no-cache .

# Known issues:

 1. Mac OS - Certificate path doesn't exist:
  * See https://stackoverflow.com/questions/38285282/where-is-the-certificates-folder-for-docker-beta-for-mac

