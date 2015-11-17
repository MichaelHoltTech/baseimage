#!/bin/sh
set -e
dir=`dirname "$0"`
cd "$dir"

set -x
curl --fail -L -o https://github.com/MichaelHoltTech/baseimage/tools/docker-bash /usr/local/bin/docker-bash
curl --fail -L -o https://github.com/MichaelHoltTech/baseimage/tools/docker-ssh /usr/local/bin/docker-ssh
curl --fail -L -o https://github.com/MichaelHoltTech/baseimage/tools/baseimage-docker-nsenter /usr/local/bin/baseimage-docker-nsenter
