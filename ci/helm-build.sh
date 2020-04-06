#!/bin/bash

set -euo pipefail

HELM=/usr/local/bin/helm
GIT=/usr/bin/git
YQ=/usr/local/bin/yq

echo ${CHART}
echo ${CHART_PATH}

${GIT} config --global user.name "Concourse-helm"
${GIT} config --global user.email "helm-ci@flexys.co.uk"

${GIT} clone helm-repo helm-updates

CV=$(${YQ} r ${CHART_PATH}/${CHART}/Chart.yaml version)
echo "Current version: ${CV}"

if [ -f helm-updates/${CHART}-${CV}.tgz ]; then
  echo "Please bump the version number!"
  exit 1
fi

${HELM} package ${CHART_PATH}/${CHART} -d helm-updates

cd helm-updates

${HELM} repo index .
${GIT} add ${CHART}*.tgz
${GIT} add index.yaml

${GIT} commit -m "New version of ${CHART}" .
