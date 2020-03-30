#!/bin/sh

mkdir .github/tmp
git remote -v

if git diff --name-status "${GIT_BRANCH:-master}" | grep -q "galaxy/Chart.yml"; then
    python .github/scripts/extract_version.py
    if [ -f .github/tmp/bump ]; then
        bump2version --current-version $(cat .github/tmp/version) $(cat .github/tmp/bump) galaxy/Chart.yaml
    fi
fi
rm -rf .github/tmp
git config --local user.email "action@github.com"
git config --local user.name "GitHub Action"
git commit -m "Automatic Version Bumping" -a