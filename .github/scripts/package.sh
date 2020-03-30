#!/bin/bash

[ -z "${GIT_TOKEN}" ] && {
    echo 'Missing input "GIT_TOKEN: ${{ secrets.GITHUB_TOKEN }}".';
    exit 1;
};
[ -z "${CHARTS_REPO}" ] && {
    echo 'Missing input "CHARTS_REPO: cloudve/helm-charts".';
    exit 1;
};

set -e

BRANCH=${CHARTS_BRANCH:-master}
CHARTS_DIR=$(basename $CHARTS_REPO)
REMOTE="https://${GITHUB_ACTOR}:${GIT_TOKEN}@github.com/${CHARTS_REPO}.git"


echo "Pushing to branch $CHARTS_BRANCH of repo $CHARTS_REPO";

cd galaxy && rm -rf charts && rm -f requirements.lock && helm dependency update && cd ..
git clone "${REMOTE}"
helm package ./galaxy/ -d "${CHARTS_DIR}/charts"
cd "${CHARTS_DIR}" && helm repo index . --url "https://raw.githubusercontent.com/${CHARTS_REPO}/${BRANCH}/"
git add . && git commit -m "Auto-packaging Galaxy Chart"
git push "${REMOTE}" HEAD:${BRANCH};
