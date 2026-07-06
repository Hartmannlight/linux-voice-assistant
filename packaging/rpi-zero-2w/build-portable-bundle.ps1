$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$outputDir = Join-Path $repoRoot "dist\rpi-zero-2w"

New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

docker buildx build `
  --platform linux/arm64 `
  -f (Join-Path $PSScriptRoot "Dockerfile.bundle") `
  --output "type=local,dest=$outputDir" `
  $repoRoot

Write-Host "Raspberry Pi Zero 2W portable bundle written to $outputDir"
