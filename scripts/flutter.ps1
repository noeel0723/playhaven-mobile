# Keep raw arguments so PowerShell does not consume Flutter flags such as -v.
$FlutterArguments = $args
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$localFlutter = Join-Path $projectRoot '.tools\flutter\bin\flutter.bat'
$previousPubCache = $env:PUB_CACHE
$previousTemp = $env:TEMP
$previousTmp = $env:TMP
$previousToolchain = @{}
foreach ($name in @('JAVA_HOME', 'ANDROID_HOME', 'ANDROID_SDK_ROOT', 'PATH', 'GRADLE_USER_HOME', 'APPDATA')) {
    $previousToolchain[$name] = [Environment]::GetEnvironmentVariable($name, 'Process')
}
$localJdk = Join-Path $projectRoot '.tools\jdk'
$localAndroid = Join-Path $projectRoot '.tools\android-sdk'
$localFlutterConfig = Join-Path $projectRoot '.tools\flutter-config'

# Flutter on Windows reads .flutter_settings from APPDATA. Isolate its config
# so an installed Android Studio cannot override this project's portable JDK.
if (Test-Path -LiteralPath (Join-Path $localFlutterConfig '.flutter_settings')) {
    $env:APPDATA = $localFlutterConfig
}

if (Test-Path -LiteralPath (Join-Path $localJdk 'bin\javac.exe')) {
    $env:JAVA_HOME = $localJdk
    $env:PATH = "$localJdk\bin;$env:PATH"
}
if (Test-Path -LiteralPath (Join-Path $localAndroid 'cmdline-tools\latest\bin\sdkmanager.bat')) {
    $env:ANDROID_HOME = $localAndroid
    $env:ANDROID_SDK_ROOT = $localAndroid
    $env:PATH = "$localAndroid\platform-tools;$env:PATH"
}
$env:GRADLE_USER_HOME = Join-Path $projectRoot '.tools\gradle'

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
    foreach ($entry in $previousToolchain.GetEnumerator()) {
        if ($null -eq $entry.Value) {
            Remove-Item -LiteralPath "Env:$($entry.Key)" -ErrorAction SilentlyContinue
        } else {
            Set-Item -LiteralPath "Env:$($entry.Key)" -Value $entry.Value
        }
    }
}
exit $flutterExitCode
