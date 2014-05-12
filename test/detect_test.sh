#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testDetect()
{
  mkdir ${BUILD_DIR}/windows

  detect

  assertAppDetected "Windows"
}

testNoDetectMissingWindowsDirectory()
{
  detect

  assertNoAppDetected
}

testNoDetectWindowsDirectoryIsFile()
{
  touch ${BUILD_DIR}/windows

  detect

  assertNoAppDetected
}