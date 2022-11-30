#!/bin/bash

if [ -d .git ]; then
    echo "git folder exists, bagging it"
    jf rt bag
else
    echo "No git folder, not bagging it"
fi