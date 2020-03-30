#!/usr/bin/env python
import json
import os
import yaml

with open(".github/tmp/version", 'w') as v:
    with open("galaxy/Chart.yaml", 'r') as chart:
        d = yaml.safe_load(chart)
        v.write(d['version'])

bump = None
labels = [l.get("name")
          for l in json.loads(os.environ['GITHUB_CONTEXT'])['event']
          ['pull_request'].get('labels', [])]
print(json.loads(os.environ['GITHUB_CONTEXT']))
print(labels)
if "patch_bump" in labels:
    bump = "patch"
elif "minor_bump" in labels:
    bump = "minor"
elif "major_bump" in labels:
    bump = "major"

if bump:
    with open("./.github/tmp/bump", 'w') as b:
        b.write(bump)
