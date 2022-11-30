#!/bin/bash
if [ -f hack/.npmrc ]; then
    echo ".npmrc found"
    mv hack/.npmrc ~
else
    echo ".npmrc not found"
fi

if [ -f hack/NuGet.Config ]; then
    echo "NuGet.Config found"
    [ ! -d ~/.nuget/NuGet ] && mkdir -p ~/.nuget/NuGet
    mv hack/NuGet.Config ~/.nuget/NuGet/NuGet.Config
fi