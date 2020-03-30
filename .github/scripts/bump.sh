#!/bin/sh

mkdir .github/tmp
if git diff --names-status master | grep -q "galaxy/Chart.yml"; then
    python .github/scripts/extract_version.py
    if [ -f .github/tmp/bump ]; then
        bump2version --current-version $(cat .github/tmp/version) $(cat .github/tmp/bump) galaxy/Chart.yaml
    fi
fi
rm -rf .github/tmp