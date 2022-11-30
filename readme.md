# Purpose
This repo is an example of how to get local, package repository configuration files, like `NuGet.Config` and `.npmrc` in to your Docker image so it can build. It also shows how to do a scan with JFrog X-Ray.

# How to run
A full demo can be executed using the `runme.sh` or `runme.ps1`. They will build 2 images. One as an example for your CI server, which scan's with JFrog. The other is as if an enduser built the same image.

# Requirements
* A JFrog instance with X-Ray.
* A user that is allowed to push/scan build information
* An identity token