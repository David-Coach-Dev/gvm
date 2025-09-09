# Simple build script for GVM

$ErrorActionPreference = "Stop"

Write-Host "Building GVM..." -ForegroundColor Green

# Build for current platform
go build -ldflags="-s -w" -o gvm.exe main.go

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Build successful: gvm.exe" -ForegroundColor Green

    # Test the binary
    try {
        $version = & .\gvm.exe --version
        Write-Host "✅ Binary test passed: $version" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Warning: Binary test failed" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Build failed" -ForegroundColor Red
    exit 1
}
