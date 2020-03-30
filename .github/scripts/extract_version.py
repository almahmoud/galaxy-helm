#!/usr/bin/env python
import json
import os
import yaml

with open(".github/tmp/version", 'w') as v:
    with open("galaxy/Chart.yaml", 'r') as chart:
        d = yaml.safe_load(chart)
        v.write(d['version'])
with open(".github/tmp/bump", 'w') as b:
    labels = [l.get("name")
              for l in json.loads(os.environ['GITHUB_CONTEXT'])['labels']]
    if "patch_bump" in labels:
        b.write("patch")
    elif "minor_bump" in labels:
        b.write("minor")
    elif "major_bump" in labels:
        b.write("major")
