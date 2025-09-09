@echo off
REM GVM Installer - One-liner style like NVM
REM Usage: curl -o install-gvm.bat https://raw.githubusercontent.com/David-Coach-Dev/gvm/main/install-gvm.bat && install-gvm.bat

echo.
echo   ██████╗ ██╗   ██╗███╗   ███╗
echo  ██╔════╝ ██║   ██║████╗ ████║
echo  ██║  ███╗██║   ██║██╔████╔██║
echo  ██║   ██║╚██╗ ██╔╝██║╚██╔╝██║
echo  ╚██████╔╝ ╚████╔╝ ██║ ╚═╝ ██║
echo   ╚═════╝   ╚═══╝  ╚═╝     ╚═╝
echo.
echo        Go Version Manager v1.0.0
echo     https://github.com/David-Coach-Dev/gvm
echo.

echo Installing GVM (Go Version Manager)...
echo.

REM Set installation directory
set "GVM_DIR=%LOCALAPPDATA%\gvm"
set "GVM_BIN=%GVM_DIR%\bin"

REM Create directories
echo ^=^> Creating directory structure...
if not exist "%GVM_DIR%" mkdir "%GVM_DIR%"
if not exist "%GVM_BIN%" mkdir "%GVM_BIN%"
if not exist "%GVM_DIR%\versions" mkdir "%GVM_DIR%\versions"
if not exist "%GVM_DIR%\temp" mkdir "%GVM_DIR%\temp"
echo    Created: %GVM_DIR%

REM Download GVM binary
echo ^=^> Downloading GVM...
set "GVM_EXE=%GVM_BIN%\gvm.exe"

REM Try to download using PowerShell
powershell -Command "& {try { Invoke-WebRequest -Uri 'https://github.com/David-Coach-Dev/gvm/releases/latest/download/gvm.exe' -OutFile '%GVM_EXE%' } catch { Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/David-Coach-Dev/gvm/main/gvm.exe' -OutFile '%GVM_EXE%' }}"

if not exist "%GVM_EXE%" (
    echo Error: Could not download GVM binary
    pause
    exit /b 1
)

echo    Downloaded: %GVM_EXE%

REM Add to PATH
echo ^=^> Configuring environment...
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH 2^>nul') do set "USER_PATH=%%B"
if not defined USER_PATH set "USER_PATH="

echo "%USER_PATH%" | find "%GVM_BIN%" >nul
if errorlevel 1 (
    setx PATH "%GVM_BIN%;%USER_PATH%" >nul
    echo    Added to PATH: %GVM_BIN%
) else (
    echo    Already in PATH: %GVM_BIN%
)

REM Set GVM_HOME
setx GVM_HOME "%GVM_DIR%" >nul
echo    Set GVM_HOME: %GVM_DIR%

REM Update current session
set "PATH=%GVM_BIN%;%PATH%"
set "GVM_HOME=%GVM_DIR%"

REM Verify installation
echo ^=^> Verifying installation...
"%GVM_EXE%" --version >nul 2>&1
if errorlevel 1 (
    echo    Warning: Could not verify GVM binary
) else (
    echo    Verified: GVM is working
)

REM Show completion message
echo.
echo ^=^> GVM installation completed!
echo.
echo To get started:
echo    1. Open a new command prompt
echo    2. Run: gvm install 1.21.0
echo    3. Run: gvm use 1.21.0
echo.
echo Commands:
echo    gvm install ^<version^>    Install a Go version
echo    gvm use ^<version^>        Switch to a Go version
echo    gvm list                 List installed versions
echo    gvm list-remote          List available versions
echo    gvm uninstall ^<version^>  Remove a Go version
echo.
echo Documentation: https://github.com/David-Coach-Dev/gvm
echo.
echo Happy coding! 🚀
echo.
echo Installation successful! ✨
echo.

pause
