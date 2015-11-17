# A minimal Ubuntu base image modified for Docker-friendliness

Baseimage is a special [Docker](https://www.docker.com) image that is configured for correct use within Docker containers based on Baseimage-docker from [Phusion](https://registry.hub.docker.com/u/phusion/baseimage/).

-----------------------------------------


**Table of contents**

 * [With a Little Help from Phusion](#phusion)
   * [What are the problems with the stock Ubuntu base image?](#stock_problems)
 * [Add SSH Keys with Environment Variables](#inspecting)
   * [Supported ENV Variables](#supported_env)
   * [Using a Data Volume](#ssh_data_volume)
 * [Connecting to Your Docker Instance](#login_ssh)
   * [Using Docker-ssh](#docker_ssh)

-----------------------------------------
Yet another [Docker](http://docker.io) base image to make it easier to connect to your
running Docker instances.

<a name="phusion"></a>
### With a Little Help from Phusion



Based on Phusion's excellent [baseimage-docker](https://github.com/phusion/baseimage-docker),
this Docker base-image features all of the awesome features you've grown to love like
working CRON jobs, a SSH server, a lightweight working init system (that actually works!),
and more.

<a name="stock_problems"></a>
### What are the problems with the stock Ubuntu base image?

Ubuntu is not designed to be run inside Docker. Its init system, Upstart, assumes that it's running on either real hardware or virtualized hardware, but not inside a Docker container. But inside a container you don't want a full system anyway, you want a minimal system. But configuring that minimal system for use within a container has many strange corner cases that are hard to get right if you are not intimately familiar with the Unix system model. This can cause a lot of strange problems.

Baseimage-docker gets everything right. The "Contents" section describes all the things that it modifies.

<a name="why_use"></a>
### Why use baseimage?

You can configure the stock `ubuntu` image yourself from your Dockerfile, so why bother using baseimage-docker?

 * Configuring the base system for Docker-friendliness is no easy task. As stated before, there are many corner cases. By the time that you've gotten all that right, you've reinvented baseimage-docker. Using baseimage-docker will save you from this effort.
 * It reduces the time needed to write a correct Dockerfile. You won't have to worry about the base system and can focus on your stack and your app.
 * It reduces the time needed to run `docker build`, allowing you to iterate your Dockerfile more quickly.
 * It reduces download time during redeploys. Docker only needs to download the base image once: during the first deploy. On every subsequent deploys, only the changes you make on top of the base image are downloaded.

<a name="add_ssh"></a>
### Add SSH Keys with Environment Variables

The first option we provide is to specify SSH keys in an environment variable when starting
your Docker instance:

    sudo docker run -d -e SSH_KEYS="$(cat ~/.authorized_keys)" rfkrocktk/baseimage

On startup of the container, it will add each SSH key found in the `SSH_KEYS`
environment variable to the `$HOME/.ssh/authorized_keys` file inside of the container. You'll
then be able to quickly and easily SSH into the Docker instance using your key.

<a name="supported_env"></a>
## Supported Environment Variables

| Name | Required | Description |
|------|----------|-------------|
| `SSH_KEYS` | No | A newline-delimited list of SSH keys in the `authorized_keys` file format. |
| `SSH_USER` | No (Defaults to `root`) | The user to set the SSH keys for, generally `root`. |

<a name="ssh_data_volume"></a>
### Using a Data Volume

This is an even easier way to maintain a Docker instance's `authorized_keys` file. In our base-image,
we've created a directory for each user called `$HOME/.ssh/authorized_keys.d/` which contains the `authorized_keys` file which is then symlinked back to `$HOME/.ssh/authorized_keys`. What this means
is that you can easily maintain the `authorized_keys` file _outside_ of the Docker instance by using
a Docker volume:

    sudo docker run -d --name "dockerduck" -v /host/path/to/dockerduck-ssh-keys:/root/.ssh/authorized_keys.d \
        rfkrocktk/baseimage

Now, simply open `/host/path/to/dockerduck-ssh-keys/authorized_keys` and add your SSH public keys there:

    sudo cat ~/.ssh/authorized_keys > /host/path/to/dockerduck-ssh-keys/authorized_keys

Done! Now just connect to your Docker instance!

Note: environment variables will _always_ overwrite `$HOME/.ssh/authorized_keys`, so don't mix and match. Use one or the other, not both.

<a name="login_ssh"></a>

### Connecting to Your Docker Instance

Now that you've added your keys to your Docker instance, you need to know its internal IP address to
connect to it. You can use the following command to see your Docker instance IP addresses:

    sudo docker inspect -f "{{.NetworkSettings.IPAddress}}" dockerduck

In my case, the IP address is `172.17.0.31`, therefore:

    ssh root@172.17.0.31

Note, you probably have to enable agent-forwarding if you're connecting to a Docker instance
hosted on a remote server, as your agent only runs on your local machine and is terminated on
your first hop.

<a name="docker_ssh"></a>
#### The `docker-ssh` tool
**_This tool is still under development_**

Looking up the IP of a container and running an SSH command quickly becomes tedious. Luckily, we provide the `docker-ssh` tool which automates this process. This tool is to be run on the *Docker host*, not inside a Docker container.

First, install the tool on the Docker host:

    curl --fail -L https://raw.githubusercontent.com/MichaelHoltTech/baseimage/master/tools/install-tools.sh -o /tmp/install-tools.sh  && \
    sudo sh /tmp/install-tools.sh

Then run the tool as follows to login to a container using SSH:

    docker-ssh YOUR-CONTAINER-ID

You can lookup `YOUR-CONTAINER-ID` by running `docker ps`.

By default, `docker-ssh` will open a Bash session. You can also tell it to run a command, and then exit:

    docker-ssh YOUR-CONTAINER-ID echo hello world
