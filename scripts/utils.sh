#!/usr/bin/env bash

function runBallerinaLangGradleBuild() {
  DEV_BALLERINA_GRADLE_COMMON_ARGS=(
    "-x" "updateVersion"
    "-x" "npmInstall"
    "-x" "npmBuild"
    "-x" "generateDocs"
  )
  DEV_BALLERINA_GRADLE_ARGS=("$@" "${DEV_BALLERINA_GRADLE_COMMON_ARGS[@]}")
  echo "Running Gradle (Ballerina Lang): ./gradlew" "${DEV_BALLERINA_GRADLE_ARGS[@]}"
  pushd "${DEV_BALLERINA_REPO}" || exit 1
  echo
  ./gradlew "${DEV_BALLERINA_GRADLE_ARGS[@]}"
  echo
  popd || exit 1
}

function printBallerinaPackInfo() {
  echo
  echo "============================"
  echo " Ballerina Pack Information "
  echo "============================"
  "${DEV_BALLERINA_PACK}"/bin/ballerina version
  echo "Ballerina Home: $("${DEV_BALLERINA_PACK}"/bin/ballerina home)"
  echo
}
