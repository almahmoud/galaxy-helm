#!/bin/sh

git remote -v
git pull
if test $(git diff --name-status origin/"${GIT_BRANCH:-master}" | grep -c "galaxy/Chart.yml") = 0 ; then
    echo "Extracting version information"
    mkdir .github/tmp
    if python .github/scripts/extract_version.py; then
        echo "Bumping version"
        echo "${CHART_VERSION}"
        echo "${VERSION_BUMP}"
        bump2version --current-version "${CHART_VERSION}" "${VERSION_BUMP}" ./galaxy/Chart.yaml
        rm -rf .github/tmp
        git config --local user.email "action@github.com"
        git config --local user.name "GitHub Action"
        git add .
        git commit -m "Automatic Version Bumping"

        REPOSITORY=${INPUT_REPOSITORY:-$GITHUB_REPOSITORY}
        REMOTE="https://${GITHUB_ACTOR}:${GIT_TOKEN}@github.com/${REPOSITORY}.git"

        echo "Push to branch $GIT_BRANCH";
        [ -z "${GIT_TOKEN}" ] && {
            echo 'Missing input "GIT_TOKEN: ${{ secrets.GITHUB_TOKEN }}".';
            exit 1;
        };

        git push "${REMOTE}" HEAD:${GIT_BRANCH} -v -v
    fi
fi