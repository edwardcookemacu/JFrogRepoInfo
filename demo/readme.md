# Notes
To build a docker image, execute `build-docker.ps1` from within Windows or `build-docker.sh` from within WSL/Linux.

The scripts will copy your `NuGet.Config` and `.npmrc`, if they exist, in to the appropriate location in the container so it will query your local machine's configured sources.

To publish and scan the build information, specify the following additional Docker arguments
```
--build-arg JFROG_ENABLED=true
--build-arg JFROG_USERNAME=<your username>
--build-arg JFROG_TOKEN=<your identity token to authenticate with Artifactory>
--build-arg JFROG_URL=<the base URL to your Artifactory instance>
--build-arg JFROG_CLI_BUILD_NAME=<the name of your build>
--build-arg JFROG_CLI_BUILD_NUMBER=<the build number for your build>
--build-arg JFROG_CLI_BUILD_PROJECT=<the project in Artifactory to associate this build with>
--build-arg "dotnetcmd=jf dotnet"
--target=jfrogscan
```

# PowerShell
For the powershell script `build-docker.ps1`, the following options are
```
-Tag <tagname> - a single tag to assign to the image, it expects a single string
-Tags @(<tag1>, <tag2>, <tag n>) - multiple tags to assign to an image, can be any arbitrary number of elements, it expects an an array
-ExtraArgs @(<arg1>, <arg2>, <arg n>) - additional arguments to pass to the `docker image build` command.
```
**Note**: If you want to specify an argument that has 2 values, say `--build-arg` you will add 2 values. One is `--build-arg` the other is the value `X=Y` like so `@("--build-arg", "X=Y")`. There is no need to wrap values containing spaces with double quotes.

# BASH Script
For the shell script `build-docker.sh`, the following options are
```
-t - comma seperated tags to add to the image
-h - a small description of available options and how to use the script
```
To add additional build arguments, append `--` to the end of the command and add additional arguments. For example
```
build-docker.sh -t example -- --build-arg X=Y
```
**Note**: For the `dotnetcmd` build argument, be sure to wrap the value in double quotes. Example: `./build-docker.sh -t test -- --build-arg="dotnetcmd=jf dotnet"`
