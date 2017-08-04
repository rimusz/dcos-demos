#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

: ${PUBLIC_AGENT_IP?"ERROR: The environment variable PUBLIC_AGENT_IP is not set."}


echo deploying Apache Drill ...

if [ "$(uname)" == "Darwin" ]; then
  # replace the template with the actual value of the broker:
  sed -i '.tmp' "s,_PUBLIC_AGENT_IP,$PUBLIC_AGENT_IP,g;" ./drill/apache-drill.json
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  # replace the template with the actual value of the broker:
  sed -i'.tmp' "s,_PUBLIC_AGENT_IP,$PUBLIC_AGENT_IP,g;" ./drill/apache-drill.json
fi
# deploy service:
dcos marathon app add ./drill/apache-drill.json
# restore template:
mv ./drill/apache-drill.json.tmp ./drill/apache-drill.json

echo DONE  ====================================================================
