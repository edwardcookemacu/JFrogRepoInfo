#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'
SHOWHELP=0

while [ $# -gt 0 ]
do
    case "$1" in
        -t)
            TAGS=$2
            shift
            ;;
        -h)
            SHOWHELP=1
            break
            ;;
        --)
            shift
            break
            ;;
        *)
            SHOWHELP=1
            break
            ;;
    esac
    shift
done

if [ "$SHOWHELP" -eq 1 ]; then
    echo "./build-docker.sh -t <comma seperated image tags> -- <build-args>"
    echo
    echo "To create an image with the tag of 'test'"
    echo "  ./build-docker.sh -t test"
    echo
    echo "To create an image with the tags, test and test1"
    echo "  ./build-docker.sh -t test,test1"
    echo
    echo "To send additional arguments to the docker image build command, add them to the end"
    echo "Example, to set the progress to plain so you can see all of the logs with a tag of test"
    echo "  ./build-docker.sh -t test -- --progress=plain"

    exit 1;
fi

DOCKER=("docker" "image" "build")

if [ -n "$TAGS" ]; then
    echo "Tags: $TAGS"
    IFS=','
    for tag in $TAGS
    do
        echo "Adding tag: $tag"
        DOCKER+=("-t" "$tag")
    done
    IFS=''
fi

while [ $# -gt 0 ]
do
    DOCKER+=($1)
    shift
done

DOCKER+=(".")

if [ -f ~/.nuget/NuGet/NuGet.Config ]; then
    echo "Copying NuGet.Config"
    cp ~/.nuget/NuGet/NuGet.Config ./hack/NuGet.Config
else
    echo -e "${RED}NuGet.Config not found, build may fail.${NC}" >&2
fi

if [ -f ~/.npmrc ]; then
    echo "Copying .npmrc"
    cp ~/.npmrc ./hack/.npmrc
else
    echo -e "${RED}.npmrc not found, build may fail.${NC}" >&2
fi

"${DOCKER[@]}"

[ -f ./hack/NuGet.Config ] && rm ./hack/NuGet.Config
[ -f ./hack/.npmrc ] && rm ./hack/.npmrc
