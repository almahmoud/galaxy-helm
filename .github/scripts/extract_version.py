#!/usr/bin/env python
import json
import os
import yaml

with open(".github/tmp/version", 'w') as v:
    with open("galaxy/Chart.yaml", 'r') as chart:
        d = yaml.safe_load(chart)
        os.environ['CHART_VERSION'] = d['version']

bump = None
labels = [l.get("name")
          for l in json.loads(os.environ['GITHUB_CONTEXT'])['event']
          ['pull_request'].get('labels', [])]

if "patch_bump" in labels:
    os.environ['VERSION_BUMP'] = "patch"
elif "minor_bump" in labels:
    os.environ['VERSION_BUMP'] = "minor"
elif "major_bump" in labels:
    os.environ['VERSION_BUMP'] = "major"
