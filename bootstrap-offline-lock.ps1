param(
    [ValidateSet('cpu', 'cuda', 'tensorrt', 'rocm')]
    [string]$Runtime = 'cpu',
    [switch]$SkipBootstrap,
    [switch]$Foreground,
    [switch]$Build
)

$ErrorActionPreference = 'Stop'

$composeByRuntime = @{
    cpu = @{
        Base = 'docker-compose.cpu.yml'
        Hardened = 'docker-compose.cpu.hardened.yml'
        Service = 'facefusion-cpu'
        Url = 'http://localhost:7865'
    }
    cuda = @{
        Base = 'docker-compose.cuda.yml'
        Hardened = 'docker-compose.cuda.hardened.yml'
        Service = 'facefusion-cuda'
        Url = 'http://localhost:7870'
    }
    tensorrt = @{
        Base = 'docker-compose.tensorrt.yml'
        Hardened = 'docker-compose.tensorrt.hardened.yml'
        Service = 'facefusion-tensorrt'
        Url = 'http://localhost:7875'
    }
    rocm = @{
        Base = 'docker-compose.rocm.yml'
        Hardened = 'docker-compose.rocm.hardened.yml'
        Service = 'facefusion-rocm'
        Url = 'http://localhost:7880'
    }
}

$config = $composeByRuntime[$Runtime]
$baseFile = $config.Base
$hardenedFile = $config.Hardened
$serviceName = $config.Service

function Invoke-Compose {
    param(
        [string[]]$Files,
        [string[]]$Arguments
    )

    $fileArgs = @()
    foreach ($file in $Files) {
        $fileArgs += @('-f', $file)
    }

    & docker compose @fileArgs @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "docker compose failed with exit code $LASTEXITCODE"
    }
}

Write-Host "Stopping existing $Runtime stack..."
Invoke-Compose -Files @($baseFile, $hardenedFile) -Arguments @('down', '--remove-orphans')

if (-not $SkipBootstrap) {
    Write-Host "Running online bootstrap to download required assets..."
    if ($Build) {
        Invoke-Compose -Files @($baseFile) -Arguments @('build')
    }
    Invoke-Compose -Files @($baseFile) -Arguments @('run', '--rm', $serviceName, 'python', 'facefusion.py', 'force-download')
}

Write-Host "Starting hardened offline-locked stack for $Runtime..."
$upArgs = @('up')
if (-not $Foreground) {
    $upArgs += '-d'
}
if ($Build) {
    $upArgs += '--build'
}
Invoke-Compose -Files @($baseFile, $hardenedFile) -Arguments $upArgs

Write-Host "Complete. Open $($config.Url)"
