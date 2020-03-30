#!/bin/sh
set -e

REPOSITORY=${INPUT_REPOSITORY:-$GITHUB_REPOSITORY}

echo "Push to branch $GIT_BRANCH";
[ -z "${GIT_TOKEN}" ] && {
    echo 'Missing input "GIT_TOKEN: ${{ secrets.GITHUB_TOKEN }}".';
    exit 1;
};

REMOTE="https://${GITHUB_ACTOR}:${GIT_TOKEN}@github.com/${REPOSITORY}.git"

git push "${REMOTE}" HEAD:${GIT_BRANCH};