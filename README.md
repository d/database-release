# Greenplum Database
[![Build Status](https://travis-ci.org/d/database-release.svg?branch=develop)](https://travis-ci.org/d/database-release)

### Prerequisite
1. [Basic understanding of BOSH](https://bosh.io/docs)
1. Rob asked me [how to take this for a spin](Rob.md)

### How to iterate quickly?

```
bosh2 create-release --force
bosh2 --environment lite update-release
bosh2 --environment lite --deployment gpdb_local --non-interactive deploy manifests/manifest.yml
```
