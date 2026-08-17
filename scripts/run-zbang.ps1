<#
.SYNOPSIS
    Runs Zbang Royale on Windows - finds (or unpacks) the Flutter SDK, wires up
    the app source, and starts the game.

.DESCRIPTION
    One command, no setup. The script:
      1. Finds a Flutter SDK: PATH first, then an already-unpacked SDK, then a
         flutter_windows_*.zip sitting in Downloads (which it unpacks once).
      2. Puts it on PATH for this session (-PersistPath to keep it for good).
      3. Makes sure the Flutter app source is present. The app lives on the
         'flutter' branch, so when the current checkout has no pubspec.yaml the
         script adds a git worktree instead of switching your branch.
      4. Runs the game, builds it, or runs the tests.

.PARAMETER Mode
    run   - launch the game in Chrome (default)
    build - build the web release into build\web
    test  - run the Dart test suite

.PARAMETER SdkRoot
    Where an unpacked SDK lives / should be unpacked to.
    Default: %LOCALAPPDATA%\flutter-sdk\flutter

.PARAMETER PersistPath
    Also add the SDK to your user PATH, so `flutter` works in any new terminal.

.EXAMPLE
    .\scripts\run-zbang.ps1
    .\scripts\run-zbang.ps1 -Mode test
    .\scripts\run-zbang.ps1 -PersistPath
#>
#Requires -Version 5.1
[CmdletBinding()]
param(
    [ValidateSet('run', 'build', 'test')]
    [string]$Mode = 'run',

    [string]$SdkRoot = (Join-Path $env:LOCALAPPDATA 'flutter-sdk\flutter'),

    [switch]$PersistPath
)

$ErrorActionPreference = 'Stop'

function Write-Step { param([string]$Text) Write-Host "==> $Text" -ForegroundColor Cyan }
function Write-Note { param([string]$Text) Write-Host "    $Text" -ForegroundColor DarkGray }

# --- where is the repo -------------------------------------------------------
$RepoRoot = Split-Path -Parent $PSScriptRoot
Write-Step "Repo: $RepoRoot"

# --- 1. locate the Flutter SDK ----------------------------------------------
function Get-DownloadsPath {
    # Downloads can be redirected (OneDrive), so ask the shell before guessing.
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders'
    $guid = '{374DE290-123F-4565-9164-39C4925E467B}'
    try {
        $raw = (Get-ItemProperty -Path $key -Name $guid -ErrorAction Stop).$guid
        $expanded = [Environment]::ExpandEnvironmentVariables($raw)
        if ($expanded -and (Test-Path $expanded)) { return $expanded }
    } catch { }
    return (Join-Path $env:USERPROFILE 'Downloads')
}

function Find-FlutterExe {
    # a) already on PATH
    $onPath = Get-Command flutter -ErrorAction SilentlyContinue
    if ($onPath) { return $onPath.Source }

    # b) unpacked at the expected location
    $expected = Join-Path $SdkRoot 'bin\flutter.bat'
    if (Test-Path $expected) { return $expected }

    # c) unpacked somewhere in Downloads
    $downloads = Get-DownloadsPath
    if (Test-Path $downloads) {
        $found = Get-ChildItem -Path $downloads -Filter 'flutter.bat' -Recurse -Depth 3 -ErrorAction SilentlyContinue |
                 Where-Object { $_.DirectoryName -like '*\flutter\bin' } |
                 Select-Object -First 1
        if ($found) { return $found.FullName }
    }
    return $null
}

function Expand-FlutterZip {
    $downloads = Get-DownloadsPath
    Write-Note "Looking for flutter_windows_*.zip in $downloads"
    $zip = Get-ChildItem -Path $downloads -Filter 'flutter_windows_*.zip' -ErrorAction SilentlyContinue |
           Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $zip) { return $null }

    # The archive already contains a top-level 'flutter' folder, so unpack into
    # the parent of $SdkRoot and let it create that folder itself.
    $target = Split-Path -Parent $SdkRoot
    Write-Step "Unpacking $($zip.Name) -> $target"
    Write-Note 'This takes a few minutes (the SDK is ~1 GB).'
    New-Item -ItemType Directory -Force -Path $target | Out-Null

    # Windows 10+ ships bsdtar, which unpacks this archive far faster than
    # Expand-Archive does. Fall back when it isn't there.
    $tar = Get-Command tar -ErrorAction SilentlyContinue
    if ($tar) {
        & $tar.Source -xf $zip.FullName -C $target
        if ($LASTEXITCODE -ne 0) { throw "tar failed to unpack $($zip.Name) (exit $LASTEXITCODE)." }
    } else {
        Expand-Archive -Path $zip.FullName -DestinationPath $target -Force
    }

    $exe = Join-Path $SdkRoot 'bin\flutter.bat'
    if (Test-Path $exe) { return $exe }
    return $null
}

Write-Step 'Locating the Flutter SDK'
$flutterExe = Find-FlutterExe
if (-not $flutterExe) { $flutterExe = Expand-FlutterZip }
if (-not $flutterExe) {
    throw @"
No Flutter SDK found.

Looked on PATH, in $SdkRoot, and for flutter_windows_*.zip in $(Get-DownloadsPath).
Download the Windows SDK zip from https://docs.flutter.dev/get-started/install/windows
into your Downloads folder, then run this script again.
"@
}
Write-Note "Using $flutterExe"

# --- 2. put it on PATH -------------------------------------------------------
$flutterBin = Split-Path -Parent $flutterExe
if (($env:Path -split ';') -notcontains $flutterBin) {
    $env:Path = "$flutterBin;$env:Path"
}
if ($PersistPath) {
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    if (($userPath -split ';') -notcontains $flutterBin) {
        [Environment]::SetEnvironmentVariable('Path', "$flutterBin;$userPath", 'User')
        Write-Note 'Added to your user PATH - new terminals will find `flutter` on their own.'
    }
}

& $flutterExe --version
if ($LASTEXITCODE -ne 0) { throw "flutter --version failed (exit $LASTEXITCODE)." }

# --- 3. make sure the app source is here ------------------------------------
# The Flutter app lives on the 'flutter' branch. Rather than switching the
# branch under you, check it out as a worktree next to the repo.
$AppDir = $RepoRoot
if (-not (Test-Path (Join-Path $RepoRoot 'pubspec.yaml'))) {
    $AppDir = Join-Path $RepoRoot '.flutter-app'
    if (-not (Test-Path (Join-Path $AppDir 'pubspec.yaml'))) {
        Write-Step "Checking out the 'flutter' branch into .flutter-app"
        git -C $RepoRoot fetch origin flutter
        if ($LASTEXITCODE -ne 0) { throw 'git fetch origin flutter failed.' }
        git -C $RepoRoot worktree add --force $AppDir origin/flutter
        if ($LASTEXITCODE -ne 0) { throw 'git worktree add failed.' }
    } else {
        Write-Step 'Updating the .flutter-app worktree'
        git -C $RepoRoot fetch origin flutter
        git -C $AppDir checkout --force origin/flutter
    }
}
Write-Note "App source: $AppDir"

Push-Location $AppDir
try {
    Write-Step 'Fetching Dart packages'
    & $flutterExe pub get
    if ($LASTEXITCODE -ne 0) { throw "flutter pub get failed (exit $LASTEXITCODE)." }

    switch ($Mode) {
        'test' {
            Write-Step 'Running the test suite'
            & $flutterExe test
            if ($LASTEXITCODE -ne 0) { throw "Tests failed (exit $LASTEXITCODE)." }
        }
        'build' {
            Write-Step 'Building the web release'
            & $flutterExe build web --release --no-web-resources-cdn
            if ($LASTEXITCODE -ne 0) { throw "Build failed (exit $LASTEXITCODE)." }
            Write-Note "Output: $(Join-Path $AppDir 'build\web')"
        }
        'run' {
            # Chrome is the nice path (hot reload, DevTools). Without it, serve
            # the app instead of failing.
            $hasChrome = $env:CHROME_EXECUTABLE -or
                (Test-Path 'C:\Program Files\Google\Chrome\Application\chrome.exe') -or
                (Test-Path 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe')
            if ($hasChrome) {
                Write-Step 'Starting the game in Chrome (press q in this window to stop)'
                & $flutterExe run -d chrome --no-web-resources-cdn
            } else {
                Write-Step 'Chrome not found - serving on http://localhost:8080 instead'
                & $flutterExe run -d web-server --web-port 8080 --no-web-resources-cdn
            }
            if ($LASTEXITCODE -ne 0) { throw "flutter run failed (exit $LASTEXITCODE)." }
        }
    }
} finally {
    Pop-Location
}

Write-Step 'Done'
