#!/bin/bash

[ -z "${GIT_TOKEN}" ] && {
    echo 'Missing input "GIT_TOKEN: ${{ secrets.GITHUB_TOKEN }}".';
    exit 1;
};
[ -z "${CHARTS_REPO}" ] && {
    echo 'Missing input "CHARTS_REPO: cloudve/helm-charts".';
    exit 1;
};

IFS=';' read -ra CHARTS_DIR <<< "${CHARTS_REPO}"

set -e

BRANCH=${CHARTS_BRANCH:-master}

echo "Pushing to branch $CHARTS_BRANCH of repo $CHARTS_REPO";

cd galaxy && rm -rf charts && rm -f requirements.lock && helm dependency update && cd ..
git pull "${CHARTS_REPO}"
helm package ./galaxy/ -d "${CHARTS_DIR[-1]}/charts"
cd "${CHARTS_DIR[-1]}" && helm repo index . --url "https://raw.githubusercontent.com/${CHARTS_REPO}/${BRANCH}/"

REMOTE="https://${GITHUB_ACTOR}:${GIT_TOKEN}@github.com/${CHARTS_REPO}.git"

git push "${REMOTE}" HEAD:${BRANCH};
