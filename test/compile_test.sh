#!/usr/bin/env bash

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testOverlayDir() {
  echo "java.runtime.version=1.7" > ${BUILD_DIR}/system.properties
  mkdir -p ${BUILD_DIR}/windows
  mkdir -p ${BUILD_DIR}/.jdk/jre/bin
  touch ${BUILD_DIR}/.jdk/jre/bin/java 
  mkdir -p ${BUILD_DIR}/.jdk-overlay/jre/lib/security
  mkdir -p ${BUILD_DIR}/.jdk-overlay/jre/bin
  touch ${BUILD_DIR}/.jdk-overlay/jre/lib/security/policy.jar

  compile

  assertCapturedSuccess
  assertTrue "Files in .jdk-overlay should be copied to .jdk." "[ -f ${BUILD_DIR}/.jdk/jre/lib/security/policy.jar ]"
  assertFalse "Original files in .jdk should be overwritten." "[ -f ${BUILD_DIR}/.jdk/jre/bin/java ]"
}

testWindowsFileCopy() {
  mkdir -p ${BUILD_DIR}/bin
  touch ${BUILD_DIR}/bin/java
  mkdir -p ${BUILD_DIR}/windows/bin
  mkdir -p ${BUILD_DIR}/windows/scripts
  touch ${BUILD_DIR}/windows/scripts/policy.jar
  mkdir -p ${BUILD_DIR}/template
  echo "existing" > ${BUILD_DIR}/template/runner
  mkdir -p ${BUILD_DIR}/windows/template
  echo "overridden" > ${BUILD_DIR}/windows/template/runner

  compile

  assertCapturedSuccess
  assertTrue "Files in windows should be copied to root." "[ -f ${BUILD_DIR}/scripts/policy.jar ]"
  assertTrue "Existing file should not be deleted." "[ -f ${BUILD_DIR}/bin/java ]"
  assertFileContains "Existing files should be overridden." "overridden" "${BUILD_DIR}/template/runner"
}

