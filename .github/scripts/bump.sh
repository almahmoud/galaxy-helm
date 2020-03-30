#!/bin/sh

git remote -v
git pull
if [ $(git diff --name-status origin/"${GIT_BRANCH:-master}" | grep -c "galaxy/Chart.yml") == 0 ] ; then
    mkdir .github/tmp
    python .github/scripts/extract_version.py
    if [ -f .github/tmp/bump ]; then
        bump2version --current-version $(cat .github/tmp/version) $(cat .github/tmp/bump) ./galaxy/Chart.yaml
        rm -rf .github/tmp
        git config --local user.email "action@github.com"
        git config --local user.name "GitHub Action"
        git add .
        git commit -m "Automatic Version Bumping"

        set -e
        REPOSITORY=${INPUT_REPOSITORY:-$GITHUB_REPOSITORY}

        echo "Push to branch $GIT_BRANCH";
        [ -z "${GIT_TOKEN}" ] && {
            echo 'Missing input "GIT_TOKEN: ${{ secrets.GITHUB_TOKEN }}".';
            exit 1;
        };

        REMOTE="https://${GITHUB_ACTOR}:${GIT_TOKEN}@github.com/${REPOSITORY}.git"

        git push "${REMOTE}" HEAD:${GIT_BRANCH};
    fi
fi