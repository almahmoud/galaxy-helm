#!/usr/bin/env python
import json
import os
import yaml

with open("galaxy/Chart.yaml", 'r') as chart:
    d = yaml.safe_load(chart)

bump = None
labels = [l.get("name")
          for l in json.loads(os.environ['GITHUB_CONTEXT'])['event']
          ['pull_request'].get('labels', [])]

if "patch_bump" in labels:
    bump = "patch"
elif "minor_bump" in labels:
    bump = "minor"
elif "major_bump" in labels:
    bump = "major"

if bump:
    print(" ".join([d['version'], bump]))
else:
    print("nobump")
