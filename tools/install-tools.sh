#!/bin/sh
set -e
dir=`dirname "$0"`
cd "$dir"


curl --fail -L https://raw.githubusercontent.com/MichaelHoltTech/baseimage/master/tools/docker-bash -o /usr/local/bin/docker-bash
curl --fail -L https://raw.githubusercontent.com/MichaelHoltTech/baseimage/master/tools/docker-ssh -o /usr/local/bin/docker-ssh
curl --fail -L https://raw.githubusercontent.com/MichaelHoltTech/baseimage/master/tools/baseimage-docker-nsenter -o /usr/local/bin/baseimage-docker-nsenter

chmod +x /usr/local/bin/docker-bash
chmod +x /usr/local/bin/docker-ssh
chmod +x /usr/local/bin/baseimage-docker-nsenter
