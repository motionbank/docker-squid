# motionbank/squid:5.7-2

> A more current fork of sameersbn/squid (Version 5.7)

- [Introduction](#introduction)
  - [Contributing](#contributing)
  - [Issues](#issues)
- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Quickstart](#quickstart)
  - [Command-line arguments](#command-line-arguments)
  - [Persistence](#persistence)
  - [Configuration](#configuration)
  - [Usage](#usage)
  - [Logs](#logs)
- [Maintenance](#maintenance)
  - [Upgrading](#upgrading)
  - [Shell Access](#shell-access)

# Introduction

`Dockerfile` to create a [Docker](https://www.docker.com/) container image for [Squid proxy server](http://www.squid-cache.org/).

Squid is a caching proxy for the Web supporting HTTP, HTTPS, FTP, and more. It reduces bandwidth and improves response times by caching and reusing frequently-requested web pages. Squid has extensive access controls and makes a great server accelerator.

## Contributing

If you find this image useful here's how you can help:

- Send a pull request with your awesome features and bug fixes

# Getting started

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/motionbank/squid) and is the recommended method of installation.

```bash
docker pull motionbank/squid:5.7-2
```

Alternatively you can build the image yourself.

```bash
docker build -t motionbank/squid github.com/motionbank/docker-squid
```

## Quickstart

Start Squid using:

```bash
docker run --name squid -d --restart=always \
  --publish 3128:3128 \
  --volume /srv/docker/squid/cache:/var/spool/squid \
  motionbank/squid:5.7-2
```

*Alternatively, you can use the sample [docker-compose.yml](docker-compose.yml) file to start the container using [Docker Compose](https://docs.docker.com/compose/)*

## Command-line arguments

You can customize the launch command of the Squid server by specifying arguments to `squid` on the `docker run` command. For example the following command prints the help menu of `squid` command:

```bash
docker run --name squid -it --rm \
  --publish 3128:3128 \
  --volume /srv/docker/squid/cache:/var/spool/squid \
  motionbank/squid:5.7-2 -h
```

## Persistence

For the cache to preserve its state across container shutdown and startup you should mount a volume at `/var/spool/squid`.

> *The [Quickstart](#quickstart) command already mounts a volume for persistence.*

SELinux users should update the security context of the host mountpoint so that it plays nicely with Docker:

```bash
mkdir -p /srv/docker/squid
chcon -Rt svirt_sandbox_file_t /srv/docker/squid
```

## Configuration

Squid is a full featured caching proxy server and a large number of configuration parameters. To configure Squid as per your requirements mount your custom configuration at `/etc/squid/squid.conf`.

```bash
docker run --name squid -d --restart=always \
  --publish 3128:3128 \
  --volume /path/to/squid.conf:/etc/squid/squid.conf \
  --volume /srv/docker/squid/cache:/var/spool/squid \
  motionbank/squid:5.7-2
```

To reload the Squid configuration on a running instance you can send the `HUP` signal to the container.

```bash
docker kill -s HUP squid
```

## Usage

Configure your web browser network/connection settings to use the proxy server which is available at `172.17.0.1:3128`

If you are using Linux then you can also add the following lines to your `.bashrc` file allowing command line applications to use the proxy server for outgoing connections.

```bash
export ftp_proxy=http://172.17.0.1:3128
export http_proxy=http://172.17.0.1:3128
export https_proxy=http://172.17.0.1:3128
```

To use Squid in your Docker containers add the following line to your `Dockerfile`.

```dockerfile
ENV http_proxy=http://172.17.0.1:3128 \
    https_proxy=http://172.17.0.1:3128 \
    ftp_proxy=http://172.17.0.1:3128
```

## Logs

Unlike the original version, this fork does not log to file, but only to stdout.

For reference, see [this comment](https://github.com/scbunn/docker-squid/issues/5#issuecomment-966579008).

# Maintenance

## Upgrading

To upgrade to newer releases:

  1. Download the updated Docker image:

  ```bash
  docker pull motionbank/squid:5.7-2
  ```

  2. Stop the currently running image:

  ```bash
  docker stop squid
  ```

  3. Remove the stopped container

  ```bash
  docker rm -v squid
  ```

  4. Start the updated image

  ```bash
  docker run -name squid -d \
    [OPTIONS] \
    motionbank/squid:5.7-2
  ```

## Shell Access

For debugging and maintenance purposes you may want access the containers shell. If you are using Docker version `1.3.0` or higher you can access a running containers shell by starting `bash` using `docker exec`:

```bash
docker exec -it squid bash
```
