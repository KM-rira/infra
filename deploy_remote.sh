#!/usr/bin/env bash
set -euo pipefail

: "${SSH_KEY_PATH:?}"
: "${TARGET_INSTANCE:?}"
: "${TARGET_INFRA_DIR:?}"
: "${GH_USER:?}"
: "${GH_PAT:?}"

ssh -i "${SSH_KEY_PATH}" -t "${TARGET_INSTANCE}" "
  export GH_USER='${GH_USER}'
  export GH_PAT='${GH_PAT}'
  cd '${TARGET_INFRA_DIR}' &&
  echo \"\$GH_PAT\" | docker login ghcr.io -u \"\$GH_USER\" --password-stdin &&
  bash ./prd_compose_deploy.sh
"
