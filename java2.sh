#!/bin/bash

PARAMS=$1
PARAMS_STR="$PARAMS"
# Split the parameter into version and flavor using space as a delimiter
VER=$(echo "$PARAMS_STR" | cut -d ',' -f 1)
FLAVOR=$(echo "$PARAMS_STR" | cut -d ',' -f 2)

if [ $# -lt  2 ]; then
     echo "Please ensure that there are two arguments supplied :- 1 is jdkversion number (Eg: 11 || 17) and 2 flavor (Eg: jdk_x64_linux || jdk_x64_windows)"
     echo "Usage = ./java.sh 11 jdk_x64_linux"
exit -1
fi
: <<'END'
BASEPATH=$(pwd)
GITHUB_API_URI=https://api.github.com/repos/adoptium/temurin${VER}-binaries/releases/latest
GITHUB_URI="https://github.com/adoptium/temurin${VER}-binaries/releases/latest"
JAVA_LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' ${GITHUB_URI})
JAVA_LATEST_VERSION=$(echo $JAVA_LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
ARTIFACT_USER="devops_art_rw"
ARTIFACT_PASS="<PASSWORD>"

PATH_TO_ALPINE_CA_CERTS_FILE_11="/e2open/jenkins/workspace/scripts/alpinecerts/cacerts_11"
PATH_TO_ALPINE_CA_CERTS_FILE_17="/e2open/jenkins/workspace/scripts/alpinecerts/cacerts_17"
END
echo "Checking the version file for version match"

# VER_FILE="${BASEPATH}/${FLAVOR}_${VER}.txt"
JAVA_LATEST_VERSION="9.0.0.1"

if [ $JAVA_LATEST_VERSION = $FLAVOR ]; then
	echo "There is no change to JDK Version today"
exit 0
else
	echo "You have $JAVA_LATEST_VERSION available for download. Proceeding to add E2open CA Certs"

# ARTIFACT=$(curl -s ${GITHUB_API_URI} | grep browser_download_url | grep -v debugimage | grep -v sources | grep ${FLAVOR} | grep tar.gz | head -1 | awk -F / '{print $NF}' | sed 's/.$//')
# ARTIFACT_URL=https://github.com/adoptium/temurin${VER}-binaries/releases/download/${JAVA_LATEST_VERSION}/${ARTIFACT}

# ARTIFACTORY_CERT_PATH="https://artifactory.dev.e2open.com/artifactory/ext-libs-dev/jdk_truststore/certs/e2open_CAs.zip"


DEST_ARTIFACTORY_URL="https://artifactory.dev.e2open.com/artifactory/ext-libs-dev/com/java/${VER}/OpenJDKU-${FLAVOR}_hotspot/latest"
DEST_ARTIFACTORY_URL2="https://artifactory.dev.e2open.com/artifactory/ext-libs-dev/com/java/${VER}/OpenJDK$-${FLAVOR}_hotspot/${JAVA_LATEST_VERSION}"
echo ${DEST_ARTIFACTORY_URL}
echo ${DEST_ARTIFACTORY_URL2}

NEW_FILE_NAME="OpenJDK-${FLAVOR}_hotspot-${JAVA_LATEST_VERSION}.tar.gz"

 echo ${DEST_ARTIFACTORY_URL}/file
echo  ${DEST_ARTIFACTORY_URL2}/${NEW_FILE_NAME}

fi