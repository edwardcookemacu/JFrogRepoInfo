param(
    [string[]] $Tags = @(),
    [string] $Tag,
    [string[]] $ExtraArgs = @()
)

try {
    if (Test-Path $env:APPDATA/NuGet/NuGet.config) {
        Copy-Item $env:APPDATA/NuGet/NuGet.config ./hack/NuGet.Config
    }
    elseif (Test-Path ~/.nuget/NuGet/NuGet.config) {
        Copy-Item ~/.nuget/config/NuGet.config ./hack/NuGet.Config
    }
    else {
        Write-Warning "Local NuGet config not found, build may fail."
    }

    if (Test-Path ~/.npmrc) {
        Copy-Item ~/.npmrc ./hack/.npmrc
    }
    else {
        Write-Warning "Local .npmrc not found, build may fail."
    }

    $commandArgs = @("image", "build")
    if ($tag -ne "") {
        $commandArgs += "-t"
        $commandArgs += $tag
    }
    if ($tags.Count -gt 0) {
        foreach ($imageTag in $tags) {
                $commandArgs += "-t"
                $commandArgs += $imageTag
        }
    }

    $commandArgs += $extraArgs
    $commandArgs += "."
    & docker $commandArgs
}
finally {
    if (Test-Path ./hack/nuget.config) {
        Remove-Item ./hack/nuget.config
    }
    if (Test-Path ./hack/.npmrc) {
        Remove-Item ./hack/.npmrc
    }
}