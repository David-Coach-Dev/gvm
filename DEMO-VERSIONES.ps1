# 🎮 SIMULACIÓN INTERACTIVA: Instalación Real de Dos Versiones de Go
Write-Host @"

██╗███╗   ██╗███████╗████████╗ █████╗ ██╗      █████╗  ██████╗██╗ ██████╗ ███╗   ██╗
██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██╔══██╗██╔════╝██║██╔═══██╗████╗  ██║
██║██╔██╗ ██║███████╗   ██║   ███████║██║     ███████║██║     ██║██║   ██║██╔██╗ ██║
██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██╔══██║██║     ██║██║   ██║██║╚██╗██║
██║██║ ╚████║███████║   ██║   ██║  ██║███████╗██║  ██║╚██████╗██║╚██████╔╝██║ ╚████║
╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝

             🎯 Instalación y Cambio Entre Go 1.21.0 y Go 1.22.0 🎯
                          Simulación de Experiencia Real

"@ -ForegroundColor Cyan

Write-Host "🎬 ESCENARIO: Desarrollador que necesita usar dos versiones de Go" -ForegroundColor Yellow
Write-Host "=" * 80 -ForegroundColor DarkGray

# Crear directorios de simulación
$baseDir = "$env:LOCALAPPDATA\gvm-demo"
$versionsDir = "$baseDir\versions"
$binDir = "$baseDir\bin"

Write-Host "`n🏗️  PASO 1: Preparando estructura de versiones" -ForegroundColor Green
New-Item -ItemType Directory -Path "$versionsDir\1.21.0" -Force | Out-Null
New-Item -ItemType Directory -Path "$versionsDir\1.22.0" -Force | Out-Null
New-Item -ItemType Directory -Path $binDir -Force | Out-Null
Write-Host "   ✅ Estructura creada en: $baseDir" -ForegroundColor White

# Simular instalación de Go 1.21.0
Write-Host "`n1️⃣  INSTALANDO GO 1.21.0" -ForegroundColor Green
Write-Host "   👤 Usuario ejecuta: gvm install 1.21.0" -ForegroundColor DarkGray

Write-Host "   🔄 Descargando Go 1.21.0..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 800
Write-Host "   📦 URL: https://golang.org/dl/go1.21.0.windows-amd64.zip" -ForegroundColor Cyan
Start-Sleep -Milliseconds 500
Write-Host "   💾 Descargando 134.3 MB..." -ForegroundColor Cyan
Start-Sleep -Milliseconds 1000

# Simular descarga con barra de progreso
for ($i = 1; $i -le 5; $i++) {
    $percent = $i * 20
    Write-Host "   📊 Progreso: $percent% [$('█' * $i)$(' ' * (5-$i))]" -ForegroundColor Green
    Start-Sleep -Milliseconds 300
}

Write-Host "   📁 Extrayendo en: $versionsDir\1.21.0" -ForegroundColor Cyan
Start-Sleep -Milliseconds 600

# Crear archivos de simulación para Go 1.21.0
@'
@echo off
echo go version go1.21.0 windows/amd64
'@ | Out-File "$versionsDir\1.21.0\go.exe" -Encoding ascii

Write-Host "   🔗 Configurando enlaces simbólicos..." -ForegroundColor Cyan
Start-Sleep -Milliseconds 400
Write-Host "   ✅ Go 1.21.0 instalado exitosamente" -ForegroundColor Green

# Activar Go 1.21.0
Write-Host "`n2️⃣  ACTIVANDO GO 1.21.0" -ForegroundColor Green
Write-Host "   👤 Usuario ejecuta: gvm use 1.21.0" -ForegroundColor DarkGray

Write-Host "   🔄 Cambiando a Go 1.21.0..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 500
Write-Host "   🎯 GOROOT = $versionsDir\1.21.0" -ForegroundColor Cyan
Write-Host "   🔗 Actualizando PATH..." -ForegroundColor Cyan
Start-Sleep -Milliseconds 400

# Copiar go.exe activo
Copy-Item "$versionsDir\1.21.0\go.exe" "$binDir\go.exe" -Force
Write-Host "   ✅ Ahora usando Go 1.21.0" -ForegroundColor Green

Write-Host "`n   👤 Usuario verifica:" -ForegroundColor DarkGray
Write-Host "   $ go version" -ForegroundColor DarkGray
Write-Host "   go version go1.21.0 windows/amd64" -ForegroundColor Green

# Simular instalación de Go 1.22.0
Write-Host "`n3️⃣  INSTALANDO GO 1.22.0" -ForegroundColor Green
Write-Host "   👤 Usuario ejecuta: gvm install 1.22.0" -ForegroundColor DarkGray

Write-Host "   🔄 Descargando Go 1.22.0..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 600
Write-Host "   📦 URL: https://golang.org/dl/go1.22.0.windows-amd64.zip" -ForegroundColor Cyan
Start-Sleep -Milliseconds 400
Write-Host "   💾 Descargando 138.7 MB..." -ForegroundColor Cyan

# Barra de progreso más rápida para la segunda
for ($i = 1; $i -le 3; $i++) {
    $percent = $i * 33
    Write-Host "   📊 Progreso: $percent% [$('█' * $i)$(' ' * (3-$i))]" -ForegroundColor Green
    Start-Sleep -Milliseconds 200
}

Write-Host "   📁 Extrayendo en: $versionsDir\1.22.0" -ForegroundColor Cyan
Start-Sleep -Milliseconds 400

# Crear archivos de simulación para Go 1.22.0
@'
@echo off
echo go version go1.22.0 windows/amd64
'@ | Out-File "$versionsDir\1.22.0\go.exe" -Encoding ascii

Write-Host "   ✅ Go 1.22.0 instalado exitosamente" -ForegroundColor Green

# Mostrar lista de versiones
Write-Host "`n4️⃣  LISTANDO VERSIONES INSTALADAS" -ForegroundColor Green
Write-Host "   👤 Usuario ejecuta: gvm list" -ForegroundColor DarkGray

Write-Host "   Versiones de Go instaladas:" -ForegroundColor White
Write-Host "   * go1.21.0  (currently active)" -ForegroundColor Green
Write-Host "     go1.22.0" -ForegroundColor White

# Cambiar a Go 1.22.0
Write-Host "`n5️⃣  CAMBIANDO A GO 1.22.0" -ForegroundColor Green
Write-Host "   👤 Usuario ejecuta: gvm use 1.22.0" -ForegroundColor DarkGray

Write-Host "   🔄 Cambiando a Go 1.22.0..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 500
Write-Host "   🎯 GOROOT = $versionsDir\1.22.0" -ForegroundColor Cyan
Write-Host "   🔗 Actualizando PATH..." -ForegroundColor Cyan
Start-Sleep -Milliseconds 400

# Actualizar go.exe activo
Copy-Item "$versionsDir\1.22.0\go.exe" "$binDir\go.exe" -Force
Write-Host "   ✅ Ahora usando Go 1.22.0" -ForegroundColor Green

Write-Host "`n   👤 Usuario verifica:" -ForegroundColor DarkGray
Write-Host "   $ go version" -ForegroundColor DarkGray
Write-Host "   go version go1.22.0 windows/amd64" -ForegroundColor Green

# Verificar cambio en lista
Write-Host "`n6️⃣  VERIFICANDO CAMBIO" -ForegroundColor Green
Write-Host "   👤 Usuario ejecuta: gvm list" -ForegroundColor DarkGray

Write-Host "   Versiones de Go instaladas:" -ForegroundColor White
Write-Host "     go1.21.0" -ForegroundColor White
Write-Host "   * go1.22.0  (currently active)" -ForegroundColor Green

# Cambiar de vuelta a 1.21.0
Write-Host "`n7️⃣  VOLVIENDO A GO 1.21.0" -ForegroundColor Green
Write-Host "   👤 Usuario ejecuta: gvm use 1.21.0" -ForegroundColor DarkGray

Write-Host "   🔄 Cambiando a Go 1.21.0..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 400
Copy-Item "$versionsDir\1.21.0\go.exe" "$binDir\go.exe" -Force
Write-Host "   ✅ Ahora usando Go 1.21.0" -ForegroundColor Green

Write-Host "`n   👤 Usuario verifica:" -ForegroundColor DarkGray
Write-Host "   $ go version" -ForegroundColor DarkGray
Write-Host "   go version go1.21.0 windows/amd64" -ForegroundColor Green

# Demostración de uso en proyectos
Write-Host "`n8️⃣  EJEMPLO DE USO EN PROYECTOS" -ForegroundColor Green
Write-Host "   💼 Proyecto A (requiere Go 1.21.0):" -ForegroundColor Yellow
Write-Host "   $ cd proyecto-legacy" -ForegroundColor DarkGray
Write-Host "   $ gvm use 1.21.0" -ForegroundColor DarkGray
Write-Host "   $ go build" -ForegroundColor DarkGray
Write-Host "   ✅ Compilado con Go 1.21.0" -ForegroundColor Green

Write-Host "`n   💼 Proyecto B (requiere Go 1.22.0):" -ForegroundColor Yellow
Write-Host "   $ cd proyecto-moderno" -ForegroundColor DarkGray
Write-Host "   $ gvm use 1.22.0" -ForegroundColor DarkGray
Write-Host "   $ go build" -ForegroundColor DarkGray
Write-Host "   ✅ Compilado con Go 1.22.0" -ForegroundColor Green

# Resumen final
Write-Host "`n" + "=" * 80 -ForegroundColor DarkGray
Write-Host "🏆 DEMOSTRACIÓN COMPLETA - GESTIÓN DE MÚLTIPLES VERSIONES" -ForegroundColor Yellow
Write-Host "=" * 80 -ForegroundColor DarkGray

Write-Host "`n✅ FUNCIONALIDADES DEMOSTRADAS:" -ForegroundColor Green
Write-Host "   🔧 Instalación automática: gvm install <version>" -ForegroundColor White
Write-Host "   🔄 Cambio entre versiones: gvm use <version>" -ForegroundColor White
Write-Host "   📋 Lista de instaladas: gvm list" -ForegroundColor White
Write-Host "   🎯 Gestión de GOROOT y PATH automática" -ForegroundColor White
Write-Host "   💼 Soporte para múltiples proyectos" -ForegroundColor White

Write-Host "`n🎯 BENEFICIOS PARA DESARROLLADORES:" -ForegroundColor Green
Write-Host "   ⚡ Cambio instantáneo entre versiones" -ForegroundColor White
Write-Host "   🚫 Sin conflictos entre proyectos" -ForegroundColor White
Write-Host "   🔧 Sin configuración manual de variables" -ForegroundColor White
Write-Host "   📦 Gestión centralizada de versiones" -ForegroundColor White

Write-Host "`n🚀 INSTALACIÓN PARA USUARIOS:" -ForegroundColor Cyan
Write-Host "iwr -useb https://raw.githubusercontent.com/David-Coach-Dev/gvm/main/install-nvm-style.ps1 | iex" -ForegroundColor White

Write-Host "`n🎉 ¡GVM Windows - La solución completa para gestión de versiones Go!" -ForegroundColor Green

# Limpiar archivos de demostración
Remove-Item $baseDir -Recurse -Force -ErrorAction SilentlyContinue
