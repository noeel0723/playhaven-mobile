# Keep raw arguments so PowerShell does not consume Flutter flags such as -v.
$FlutterArguments = $args
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$localFlutter = Join-Path $projectRoot '.tools\flutter\bin\flutter.bat'
$previousPubCache = $env:PUB_CACHE
$previousTemp = $env:TEMP
$previousTmp = $env:TMP

if (Test-Path -LiteralPath $localFlutter) {
    $flutterExecutable = $localFlutter
    $env:PUB_CACHE = Join-Path $projectRoot '.tools\pub-cache'
    $toolTemp = Join-Path $projectRoot '.tools\tmp'
    [void][System.IO.Directory]::CreateDirectory($toolTemp)
    $env:TEMP = $toolTemp
    $env:TMP = $toolTemp
} else {
    $command = Get-Command flutter -ErrorAction SilentlyContinue
    if ($null -eq $command) {
        throw 'Flutter belum tersedia. Instal SDK resmi dan tambahkan bin ke PATH; lihat README.md.'
    }
    $flutterExecutable = $command.Source
}

if (!$FlutterArguments -or $FlutterArguments.Count -eq 0) {
    $FlutterArguments = @('--version')
}

Push-Location -LiteralPath $projectRoot
try {
    & $flutterExecutable @FlutterArguments
    $flutterExitCode = $LASTEXITCODE
} finally {
    Pop-Location
    $env:PUB_CACHE = $previousPubCache
    $env:TEMP = $previousTemp
    $env:TMP = $previousTmp
}
exit $flutterExitCode
