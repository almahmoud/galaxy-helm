#!/bin/sh

mkdir .github/tmp
git remote -v
git pull
if git diff --name-status origin/"${GIT_BRANCH:-master}" | grep -q "galaxy/Chart.yml"; then
    python .github/scripts/extract_version.py
    cat .github/tmp/version
    cat .github/tmp/bump
    if [ -f .github/tmp/bump ]; then
        bump2version --current-version $(cat .github/tmp/version) $(cat .github/tmp/bump) ./galaxy/Chart.yaml
        cat ./galaxy/Chart.yaml
    fi
fi
rm -rf .github/tmp
git config --local user.email "action@github.com"
git config --local user.name "GitHub Action"
git add .
git commit -m "Automatic Version Bumping"