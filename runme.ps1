docker image build -t jfrog --progress=plain ./jfrog-base

$currentLocation = Get-Location
Set-Location ./demo

./build-docker.ps1 -tag "test-buildserver" `
                -extraArgs @( `
                    "--progress=plain", `
                    #"--no-cache", `
                    "--build-arg", 'dotnetcmd="jf dotnet --build-name ${JFROG_CLI_BUILD_NAME} --build-number ${JFROG_CLI_BUILD_NUMBER}"', `
                    "--build-arg", "JFROG_CLI_BUILD_NAME=test-build", `
                    "--build-arg", "JFROG_CLI_BUILD_NUMBER=$(Get-Date -Format "yyyy.MM.dd-hh.mm.ss")", `
                    "--build-arg", "JFROG_CLI_BUILD_PROJECT=${JFROG_PROJECT}", `
                    "--build-arg", "JFROG_URL=${JFROG_URL}", `
                    "--build-arg", "JFROG_ENABLED=true", `
                    "--build-arg", "JFROG_TOKEN=${JFROG_TOKEN}", `
                    "--build-arg", "JFROG_USERNAME=${JFROG_USERNAME}", `
                    "--target=jfrogscan"
                    )

./build-docker.ps1 -tag "test-enduser" -extraArgs "--progress=plain"

write-host "Expecting at least test-buildserver1, test-buildserver2 and test-enduser"

docker image ls | select-string -pattern "^test" | write-host

Set-Location $currentLocation