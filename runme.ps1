<#
    .SYNOPSIS
    Builds the example images

    .PARAMETER BuildNumber
    The build number to associate this image to in JFrog

    .PARAMETER Project
    The project to associate this build with within JFrog

    .PARAMETER Url
    The URL of your JFrog instance

    .PARAMETER Token
    The identity token to authenticate to JFrog with

    .PARAMETER Username
    The username to authenticate to JFrog with

    .PARAMETER BuildName
    The name of the build to associate this image with
#>
[CmdletBinding()]
param (
    [string]
    $BuildNumber = (Get-Date -Format "yyyy.MM.dd-hh.mm.ss"),

    [Parameter(Mandatory = $true)]
    [string]
    $Project,

    [Parameter(Mandatory = $true)]
    [string]
    $Url,

    [Parameter(Mandatory = $true)]
    [string]
    $Token,

    [Parameter(Mandatory = $true)]
    [string]
    $Username,

    [string]
    $BuildName = "test-build"
)
docker image build -t jfrog --progress=plain ./jfrog-base

Push-Location

Copy-Item -Recurse .git demo

Set-Location ./demo

./build-docker.ps1 -tags @("test-buildserver1", "test-buildserver2") `
                -extraArgs @( `
                    "--progress=plain", `
                    #"--no-cache", `
                    "--build-arg", 'dotnetcmd=jf dotnet', `
                    "--build-arg", "JFROG_CLI_BUILD_NAME=$BuildName", `
                    "--build-arg", "JFROG_CLI_BUILD_NUMBER=$BuildNumber", `
                    "--build-arg", "JFROG_CLI_BUILD_PROJECT=$Project", `
                    "--build-arg", "JFROG_URL=$Url", `
                    "--build-arg", "JFROG_ENABLED=true", `
                    "--build-arg", "JFROG_TOKEN=$Token", `
                    "--build-arg", "JFROG_USERNAME=$Username", `
                    "--target=jfrogscan"
                    )

#./build-docker.ps1 -tag "test-enduser" -extraArgs @("--progress=plain", "--no-cache")

write-host "Expecting at least test-buildserver1, test-buildserver2 and test-enduser"

docker image ls | select-string -pattern "^test" | write-host
Remove-Item -Recurse -Force .git
Pop-Location