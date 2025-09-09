# GVM Installer Script - Equivalent to NVM for Node.js
# Usage: iwr -useb https://raw.githubusercontent.com/David-Coach-Dev/gvm/main/install.ps1 | iex

param(
    [string]$Version = "latest",
    [string]$InstallDir = "$env:LOCALAPPDATA\gvm"
)

$ErrorActionPreference = "Stop"

# ASCII Art Banner like NVM
Write-Host @"

  ██████╗ ██╗   ██╗███╗   ███╗
 ██╔════╝ ██║   ██║████╗ ████║
 ██║  ███╗██║   ██║██╔████╔██║
 ██║   ██║╚██╗ ██╔╝██║╚██╔╝██║
 ╚██████╔╝ ╚████╔╝ ██║ ╚═╝ ██║
  ╚═════╝   ╚═══╝  ╚═╝     ╚═╝

       Go Version Manager v1.0.0
    https://github.com/David-Coach-Dev/gvm

"@ -ForegroundColor Cyan

Write-Host "Installing GVM (Go Version Manager)..." -ForegroundColor Green
Write-Host ""

# Function to download file with progress
function Download-File {
    param(
        [string]$Url,
        [string]$OutputPath
    )

    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($Url, $OutputPath)
        return $true
    } catch {
        Write-Host "Failed to download from $Url" -ForegroundColor Red
        return $false
    }
}

# Function to get latest release version
function Get-LatestVersion {
    try {
        $apiUrl = "https://api.github.com/repos/David-Coach-Dev/gvm/releases/latest"
        $response = Invoke-RestMethod -Uri $apiUrl -ErrorAction SilentlyContinue
        return $response.tag_name
    } catch {
        return "v1.0.0"  # fallback version
    }
}

# Main installation function
function Install-GVM {
    Write-Host "=> Creating directory structure..." -ForegroundColor Yellow

    # Create directories
    $gvmBin = "$InstallDir\bin"
    $gvmVersions = "$InstallDir\versions"
    $gvmTemp = "$InstallDir\temp"

    @($InstallDir, $gvmBin, $gvmVersions, $gvmTemp) | ForEach-Object {
        if (!(Test-Path $_)) {
            New-Item -ItemType Directory -Path $_ -Force | Out-Null
            Write-Host "   Created: $_" -ForegroundColor Gray
        }
    }

    # Determine version to install
    if ($Version -eq "latest") {
        Write-Host "=> Fetching latest version..." -ForegroundColor Yellow
        $Version = Get-LatestVersion
    }

    Write-Host "=> Downloading GVM $Version..." -ForegroundColor Yellow

    # Download GVM binary
    $gvmUrl = "https://github.com/David-Coach-Dev/gvm/releases/download/$Version/gvm.exe"
    $gvmPath = "$gvmBin\gvm.exe"

    # Fallback URLs if GitHub release doesn't exist
    $fallbackUrls = @(
        "https://github.com/David-Coach-Dev/gvm/releases/latest/download/gvm.exe",
        "https://raw.githubusercontent.com/David-Coach-Dev/gvm/main/gvm.exe"
    )

    $downloaded = $false

    # Try main URL first
    if (Download-File -Url $gvmUrl -OutputPath $gvmPath) {
        $downloaded = $true
    } else {
        # Try fallback URLs
        foreach ($url in $fallbackUrls) {
            Write-Host "   Trying fallback: $url" -ForegroundColor Gray
            if (Download-File -Url $url -OutputPath $gvmPath) {
                $downloaded = $true
                break
            }
        }
    }

    if (!$downloaded) {
        throw "Could not download GVM binary from any source"
    }

    Write-Host "   Downloaded: $gvmPath" -ForegroundColor Green

    # Verify the binary works
    try {
        $versionOutput = & $gvmPath --version 2>$null
        Write-Host "   Verified: GVM is working" -ForegroundColor Green
    } catch {
        Write-Host "   Warning: Could not verify GVM binary" -ForegroundColor Yellow
    }

    return $gvmPath
}

# Function to configure environment
function Configure-Environment {
    param([string]$GvmBin)

    Write-Host "=> Configuring environment..." -ForegroundColor Yellow

    # Add to user PATH
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($currentPath -notlike "*$GvmBin*") {
        $newPath = "$GvmBin;$currentPath"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Host "   Added to PATH: $GvmBin" -ForegroundColor Green
    } else {
        Write-Host "   Already in PATH: $GvmBin" -ForegroundColor Gray
    }

    # Set GVM_HOME environment variable
    [Environment]::SetEnvironmentVariable("GVM_HOME", $InstallDir, "User")
    Write-Host "   Set GVM_HOME: $InstallDir" -ForegroundColor Green

    # Update current session
    $env:PATH = "$GvmBin;$env:PATH"
    $env:GVM_HOME = $InstallDir
}

# Function to create shell integration
function Create-ShellIntegration {
    Write-Host "=> Setting up shell integration..." -ForegroundColor Yellow

    # Create PowerShell profile integration
    $profileDir = Split-Path $PROFILE -Parent
    if (!(Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }

    $gvmInit = @"

# GVM (Go Version Manager) integration
if (Test-Path "$InstallDir\bin\gvm.exe") {
    # Add GVM to PATH if not already present
    if ($env:PATH -notlike "*$InstallDir\bin*") {
        $env:PATH = "$InstallDir\bin;" + $env:PATH
    }

    # Set GVM_HOME
    $env:GVM_HOME = "$InstallDir"

    # Optional: Auto-switch Go version based on .go-version file
    function gvm-auto-switch {
        if (Test-Path ".go-version") {
            $version = Get-Content ".go-version" -First 1
            if ($version) {
                & gvm use $version.Trim()
            }
        }
    }

    # Add auto-switch to prompt (optional)
    # gvm-auto-switch
}

"@

    # Add to PowerShell profile
    if (!(Test-Path $PROFILE)) {
        New-Item -ItemType File -Path $PROFILE -Force | Out-Null
    }

    $profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
    if ($profileContent -notlike "*GVM (Go Version Manager)*") {
        Add-Content -Path $PROFILE -Value $gvmInit
        Write-Host "   Added GVM to PowerShell profile" -ForegroundColor Green
    } else {
        Write-Host "   GVM already in PowerShell profile" -ForegroundColor Gray
    }
}

# Function to show completion message
function Show-CompletionMessage {
    Write-Host ""
    Write-Host "=> GVM installation completed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "To get started:" -ForegroundColor Cyan
    Write-Host "   1. Close and reopen your terminal" -ForegroundColor White
    Write-Host "   2. Run: gvm install 1.21.0" -ForegroundColor White
    Write-Host "   3. Run: gvm use 1.21.0" -ForegroundColor White
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor Cyan
    Write-Host "   gvm install <version>    Install a Go version" -ForegroundColor White
    Write-Host "   gvm use <version>        Switch to a Go version" -ForegroundColor White
    Write-Host "   gvm list                 List installed versions" -ForegroundColor White
    Write-Host "   gvm list-remote          List available versions" -ForegroundColor White
    Write-Host "   gvm uninstall <version>  Remove a Go version" -ForegroundColor White
    Write-Host ""
    Write-Host "Documentation: https://github.com/David-Coach-Dev/gvm" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Happy coding! 🚀" -ForegroundColor Green
}

# Main execution
try {
    $gvmPath = Install-GVM
    $gvmBin = Split-Path $gvmPath -Parent
    Configure-Environment -GvmBin $gvmBin
    Create-ShellIntegration
    Show-CompletionMessage

    Write-Host ""
    Write-Host "Installation successful! ✨" -ForegroundColor Green

} catch {
    Write-Host ""
    Write-Host "Installation failed: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "For help, visit: https://github.com/David-Coach-Dev/gvm/issues" -ForegroundColor Yellow
    exit 1
}
