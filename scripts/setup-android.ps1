param(
    [switch] $ReviewLicenses,
    [switch] $InstallPackages
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$toolsRoot = Join-Path $projectRoot '.tools'
$downloads = Join-Path $toolsRoot 'downloads'
$jdkRoot = Join-Path $toolsRoot 'jdk'
$sdkRoot = Join-Path $toolsRoot 'android-sdk'
$commandLineTools = Join-Path $sdkRoot 'cmdline-tools\latest'
[void][System.IO.Directory]::CreateDirectory($downloads)

function Get-VerifiedArchive {
    param([string] $Url, [string] $Path, [string] $Sha256)
    if (!(Test-Path -LiteralPath $Path)) {
        Write-Host "Mengunduh $([System.IO.Path]::GetFileName($Path)) ..."
        $previousProgress = $ProgressPreference
        try {
            $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $Url -OutFile $Path
        } finally {
            $ProgressPreference = $previousProgress
        }
    }
    $actual = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    if ($actual -ne $Sha256) {
        throw "Checksum tidak cocok: $Path. Periksa/hapus berkas unduhan ini sebelum mencoba lagi."
    }
    return $Path
}

if (!(Test-Path -LiteralPath (Join-Path $jdkRoot 'bin\javac.exe'))) {
    $jdkArchive = Get-VerifiedArchive `
        -Url 'https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13%2B9/OpenJDK21U-jdk_x64_windows_hotspot_21.0.13_9.zip' `
        -Path (Join-Path $downloads 'temurin-21.0.13-9-windows-x64.zip') `
        -Sha256 'a4dbaa05fca4bd89d84584e58c459bd732efebb1722af80ab13c6516832004f9'
    $jdkStaging = Join-Path $downloads 'jdk-21.0.13-9'
    Expand-Archive -LiteralPath $jdkArchive -DestinationPath $jdkStaging -Force
    $extractedJdk = Get-ChildItem -LiteralPath $jdkStaging -Directory |
        Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'bin\javac.exe') } |
        Select-Object -First 1
    if ($null -eq $extractedJdk) { throw 'JDK tidak ditemukan dalam arsip.' }
    if (Test-Path -LiteralPath $jdkRoot) {
        throw 'Folder .tools/jdk sudah ada tetapi tidak lengkap. Periksa sebelum mencoba lagi.'
    }
    Copy-Item -LiteralPath $extractedJdk.FullName -Destination $jdkRoot -Recurse
}

if (!(Test-Path -LiteralPath (Join-Path $commandLineTools 'bin\sdkmanager.bat'))) {
    $sdkArchive = Get-VerifiedArchive `
        -Url 'https://dl.google.com/android/repository/commandlinetools-win-15859902_latest.zip' `
        -Path (Join-Path $downloads 'commandlinetools-win-15859902.zip') `
        -Sha256 '90ae805d20434428bffcb699c290860f19bb5f66a67e6b330067e3de801fb04a'
    $sdkStaging = Join-Path $downloads 'commandlinetools-15859902'
    Expand-Archive -LiteralPath $sdkArchive -DestinationPath $sdkStaging -Force
    [void][System.IO.Directory]::CreateDirectory((Split-Path -Parent $commandLineTools))
    if (Test-Path -LiteralPath $commandLineTools) {
        throw 'Folder command-line tools sudah ada tetapi tidak lengkap. Periksa sebelum mencoba lagi.'
    }
    Copy-Item -LiteralPath (Join-Path $sdkStaging 'cmdline-tools') -Destination $commandLineTools -Recurse
}

$previousEnvironment = @{}
foreach ($name in @('JAVA_HOME', 'ANDROID_HOME', 'ANDROID_SDK_ROOT', 'PATH')) {
    $previousEnvironment[$name] = [Environment]::GetEnvironmentVariable($name, 'Process')
}
$sdkmanager = Join-Path $commandLineTools 'bin\sdkmanager.bat'
try {
    $env:JAVA_HOME = $jdkRoot
    $env:ANDROID_HOME = $sdkRoot
    $env:ANDROID_SDK_ROOT = $sdkRoot
    $env:PATH = "$jdkRoot\bin;$env:PATH"
    & (Join-Path $jdkRoot 'bin\java.exe') -version
    if ($LASTEXITCODE -ne 0) { throw 'Java belum dapat dijalankan.' }
    & $sdkmanager "--sdk_root=$sdkRoot" --version
    if ($LASTEXITCODE -ne 0) { throw 'Android command-line tools belum dapat dijalankan.' }

    if ($ReviewLicenses) {
        # Interactive: read the terms and choose whether to accept each license.
        & $sdkmanager "--sdk_root=$sdkRoot" --licenses
        if ($LASTEXITCODE -ne 0) { throw 'Review lisensi belum selesai.' }
    }

    if ($InstallPackages) {
        & $sdkmanager "--sdk_root=$sdkRoot" --install `
            'platform-tools' 'platforms;android-36' 'build-tools;36.0.0'
        if ($LASTEXITCODE -ne 0) { throw 'Instalasi paket Android SDK belum selesai.' }
        foreach ($requiredFile in @('platform-tools\adb.exe', 'platforms\android-36\android.jar', 'build-tools\36.0.0\aapt.exe')) {
            if (!(Test-Path -LiteralPath (Join-Path $sdkRoot $requiredFile))) {
                throw "Paket SDK belum lengkap: $requiredFile. Periksa persetujuan lisensi dan hasil unduhan."
            }
        }
    }

    # Dart Code passes dart.env values literally. Generate absolute paths in a
    # machine-local workspace instead of committing this computer's paths.
    $flutterRoot = Join-Path $toolsRoot 'flutter'
    $flutterConfigRoot = Join-Path $toolsRoot 'flutter-config'
    [void][System.IO.Directory]::CreateDirectory($flutterConfigRoot)
    @{
        'jdk-dir' = $jdkRoot
        'android-sdk' = $sdkRoot
    } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $flutterConfigRoot '.flutter_settings') -Encoding UTF8
    $tempRoot = Join-Path $toolsRoot 'tmp'
    [void][System.IO.Directory]::CreateDirectory($tempRoot)
    $toolEnvironment = [ordered]@{
        JAVA_HOME = $jdkRoot
        ANDROID_HOME = $sdkRoot
        ANDROID_SDK_ROOT = $sdkRoot
        PUB_CACHE = (Join-Path $toolsRoot 'pub-cache')
        GRADLE_USER_HOME = (Join-Path $toolsRoot 'gradle')
        TEMP = $tempRoot
        TMP = $tempRoot
        APPDATA = $flutterConfigRoot
    }
    $terminalEnvironment = [ordered]@{}
    foreach ($entry in $toolEnvironment.GetEnumerator()) {
        # Keep the terminal's normal APPDATA for other programs such as Code.
        if ($entry.Key -ne 'APPDATA') {
            $terminalEnvironment[$entry.Key] = $entry.Value
        }
    }
    $terminalEnvironment['PATH'] = "$jdkRoot\bin;$sdkRoot\platform-tools;$commandLineTools\bin;$flutterRoot\bin;" + '${env:PATH}'
    $workspace = [ordered]@{
        folders = @(@{ path = '..' })
        settings = [ordered]@{
            'dart.flutterSdkPath' = $flutterRoot
            'dart.env' = $toolEnvironment
            'terminal.integrated.env.windows' = $terminalEnvironment
            'java.autobuild.enabled' = $false
            'java.import.gradle.enabled' = $false
            'java.import.maven.enabled' = $false
            'java.configuration.updateBuildConfiguration' = 'disabled'
            'gradle.autoDetect' = 'off'
        }
    }
    $vscodeRoot = Join-Path $projectRoot '.vscode'
    [void][System.IO.Directory]::CreateDirectory($vscodeRoot)
    $workspacePath = Join-Path $vscodeRoot 'playhaven.local.code-workspace'
    $workspace | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $workspacePath -Encoding UTF8

    Write-Host 'Tooling portabel tersedia di .tools/jdk dan .tools/android-sdk.'
    Write-Host 'Buka VS Code: code .vscode/playhaven.local.code-workspace'
    $missingPackages = @('platform-tools\adb.exe', 'platforms\android-36\android.jar', 'build-tools\36.0.0\aapt.exe') |
        Where-Object { !(Test-Path -LiteralPath (Join-Path $sdkRoot $_)) }
    if ($missingPackages) {
        Write-Host 'Selanjutnya: .\scripts\setup-android.ps1 -ReviewLicenses -InstallPackages'
    } else {
        Write-Host 'Paket Android minimum lengkap. Periksa: .\scripts\flutter.ps1 doctor -v'
    }
} finally {
    foreach ($entry in $previousEnvironment.GetEnumerator()) {
        if ($null -eq $entry.Value) {
            Remove-Item -LiteralPath "Env:$($entry.Key)" -ErrorAction SilentlyContinue
        } else {
            Set-Item -LiteralPath "Env:$($entry.Key)" -Value $entry.Value
        }
    }
}
