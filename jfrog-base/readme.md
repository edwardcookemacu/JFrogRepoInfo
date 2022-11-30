# Description
This Docker image will contain the JFrog CLI that can be used by the build stages instead of each build downloading a copy of the JFrog CLI.

To build, use a simple `docker image build .` command, specifying a tag. Example: `docker image build -t jfrog .`

It uses Alpine as the base image, so the final image is nice and small.