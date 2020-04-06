#!/bin/bash -x

set -euo pipefail

HELM=/usr/local/bin/helm

${HELM} lint ${CHART_PATH}/${CHART}

echo Files with trailing spaces:
find ${CHART_PATH}/${CHART} -type f -exec egrep -l " +$" {} \;
