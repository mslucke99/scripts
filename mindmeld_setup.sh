#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

mkdir my_mm_ws
./python_env_setup.sh &
wait
echo "[debug] running mindmeld setup script"
pyenv install 3.6
cd my_mm_ws
cat <<EXCL >> ./envrc
# -*- mode: sh; -*-
# (rootdir)/.envrc : direnv configuration file
# see https://direnv.net/
# pyversion=\$(head .python-version)
# pvenv=\$(head     .python-virtualenv)

pyversion=3.6
pvenv=mindmeld

use python \${pyversion}
# Create the virtualenv if not yet done
layout virtualenv \${pyversion} \${pvenv}
# activate it
layout activate \${pvenv}-\${pyversion}

EXCL

echo "[debug] about to run docker commands"
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # bash -c "$(curl -s  https://raw.githubusercontent.com/cisco/mindmeld/master/scripts/mindmeld_init.sh)"
    sudo docker pull docker.elastic.co/elasticsearch/elasticsearch:7.8.0 && sudo docker run -d -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.8.0
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    sudo docker pull docker.elastic.co/elasticsearch/elasticsearch:7.8.0 && sudo docker run -ti -d -p 0.0.0.0:9200:9200 -p 0.0.0.0:9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.8.0
fi

pip3 install mindmeld

