#!/bin/bash
if [ "$JFROG_ENABLED" == "true" ]; then
    echo "Configuring JFrog CLI"

    if [ -z ${JFROG_USERNAME} ]; then
        echo "Username not set, aborting"
        exit 1
    fi

    if [ -z ${JFROG_TOKEN} ]; then
        echo "Token not set, aborting"
        exit 1
    fi

    if [ -z ${JFROG_URL} ]; then
        echo "JFrog URL not set, aborting"
        exit 1
    fi
    
    jf c add --url ${JFROG_URL} --interactive=false --user ${JFROG_USERNAME} --access-token ${JFROG_TOKEN} artifactory
    jf dotnet-config --repo-resolve nuget --server-id-resolve artifactory
    jf npm-config --repo-resolve npm --server-id-resolve artifactory
else
    echo "JFrog not enabled"
fi