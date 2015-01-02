#!/usr/bin/env bash

set -e

tar cf - . | docker run --rm -e \
  BUILDPACK_URL=https://github.com/heroku/heroku-buildpack-testrunner \
  -v /tmp/app-cache/windows-slug:/tmp/cache:rw -i flynn/slugbuilder - > slug.tgz

TARGET=$1
if [ -z "$TARGET" ]; then
  TARGET=tests
fi

cat slug.tgz | docker run --rm -i -a stdin -a stdout -a stderr \
  -e SHUNIT_HOME=/app/.shunit2 flynn/slugrunner start $TARGET