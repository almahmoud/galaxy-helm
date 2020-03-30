#!/bin/sh

git remote -v
git pull
if ! [ git diff --name-status origin/"${GIT_BRANCH:-master}" | grep -q "galaxy/Chart.yml" ]; then
    mkdir .github/tmp
    python .github/scripts/extract_version.py
    if [ -f .github/tmp/bump ]; then
        bump2version --current-version $(cat .github/tmp/version) $(cat .github/tmp/bump) ./galaxy/Chart.yaml
        rm -rf .github/tmp
        git config --local user.email "action@github.com"
        git config --local user.name "GitHub Action"
        git add .
        git commit -m "Automatic Version Bumping"
    fi
fi