#!/bin/bash

while getopts n:p:u:t:U: opt
do
    case "$opt" in
        n) JFROG_BUILD_NAME=$OPTARG;;
        p) JFROG_PROJECT=$OPTARG;;
        u) JFROG_URL=$OPTARG;;
        t) JFROG_TOKEN=$OPTARG;;
        U) JFROG_USERNAME=$OPTARG;;
        b) JFROG_BUILDNUMBER=$OPTARG;;
    esac
done

if [ -z $JFROG_BUILD_NAME ]; then
    echo "Missing build name"
    SHOWHELP=1
fi

if [ -z $JFROG_PROJECT ]; then
    echo "Missing project"
    SHOWHELP=1
fi

if [ -z $JFROG_URL ]; then
    echo "Missing URL"
    SHOWHELP=1
fi

if [ -z $JFROG_TOKEN ]; then
    echo "Missing token"
    SHOWHELP=1
fi

if [ -z $JFROG_USERNAME ]; then
    echo "Missing username"
    SHOWHELP=1
fi

if [ -z $JFROG_BUILDNUMBER ]; then
    JFROG_BUILDNUMBER=$(date +"%4Y.%m.%d-%H.%M.%S")
fi


if [ "$SHOWHELP" == "1" ]; then
    echo "At least one missing parameter"
    echo "All are required"
    echo "-n <Build name to report to JFrog>"
    echo "-p <Project name in JFrog>"
    echo "-u <JFrog instance URL>"
    echo "-t <Token to authenticate to JFrog with>"
    echo "-U <Username to authenticate to JFrog with>"
    echo "Optional:"
    echo "-b <Build Number>, default to the current date/time in the format of %4Y.%m.%d-%H.%M.%S - example $(date +"%4Y.%m.%d-%H.%M.%S")"
    exit 1
fi

docker image build -t jfrog --progress=plain ./jfrog-base

pushd
cp -r .git demo
cd ./demo

./build-docker.sh -t "test-buildserver1,test-buildserver2" -- \
                    --progress=plain \
                    --build-arg dotnetcmd='jf dotnet --build-name ${JFROG_CLI_BUILD_NAME} --build-number ${JFROG_CLI_BUILD_NUMBER}' \
                    --build-arg JFROG_CLI_BUILD_NAME=${JFROG_BUILD_NAME} \
                    --build-arg JFROG_CLI_BUILD_NUMBER=$(date +"%4Y.%m.%d-%H.%M.%S") \
                    --build-arg JFROG_CLI_BUILD_PROJECT=${JFROG_PROJECT} \
                    --build-arg JFROG_URL=${JFROG_URL} \
                    --build-arg JFROG_ENABLED=true \
                    --build-arg JFROG_TOKEN=${JFROG_TOKEN} \
                    --build-arg JFROG_USERNAME=${JFROG_USERNAME} \
                    --target=jfrogscan

./build-docker.sh -t "test-enduser"

rm -rf .git
popd

echo "Expecting at least test-buildserver1, test-buildserver2 and test-enduser"

docker image ls | grep "^test"
