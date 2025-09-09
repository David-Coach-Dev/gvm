# GVM - Go Version Manager for Windows

## 📁 Estructura de Archivos

```
gvm/
├── 📄 main.go                    # Entrada principal del programa
├── 📄 go.mod                     # Dependencias de Go
├── 📄 go.sum                     # Checksums de dependencias
├── 📄 LICENSE                    # Licencia MIT
├── 📄 README.md                  # Documentación principal
├── 📄 .gitignore                 # Archivos ignorados por Git
├── 📄 .editorconfig              # Configuración del editor
│
├── 🗂️ cmd/                       # Comandos de la CLI
│   ├── root.go                   # Comando raíz y configuración
│   ├── install.go                # Comando: gvm install
│   ├── use.go                    # Comando: gvm use  
│   ├── list.go                   # Comando: gvm list
│   ├── listall.go                # Comando: gvm listall
│   ├── uninstall.go              # Comando: gvm uninstall
│   ├── version.go                # Comando: gvm version
│   ├── util.go                   # Utilidades comunes
│   └── bootstrap.go              # Descarga directa de Go
│
├── 🗂️ .github/workflows/         # CI/CD
│   └── release.yml               # Build y release automático (solo Windows)
│
├── 🚀 install-nvm-style.ps1      # Instalador PowerShell (principal)
├── 🚀 install-gvm.bat            # Instalador CMD (Windows)
├── 🔧 build.ps1                  # Build script PowerShell
└── � ESTRUCTURA.md              # Este archivo
```

## 🎯 Archivos Principales

### **Instaladores (Solo Windows)**

- `install-nvm-style.ps1` - Instalador principal para Windows PowerShell
- `install-gvm.bat` - Instalador alternativo para CMD Windows

### **Código Fuente**

- `main.go` - Punto de entrada, configuración CLI con Cobra
- `cmd/*.go` - Implementación de todos los comandos

### **Automatización**

- `.github/workflows/release.yml` - CI/CD para builds de Windows
- `build.ps1` - Script de build para Windows

## 🚀 Uso Rápido

### Instalación One-liner

```powershell
# PowerShell (Recomendado)
iwr -useb https://raw.githubusercontent.com/David-Coach-Dev/gvm/main/install-nvm-style.ps1 | iex

# CMD (Windows)
curl -o install-gvm.bat https://raw.githubusercontent.com/David-Coach-Dev/gvm/main/install-gvm.bat && install-gvm.bat
```

### Comandos Básicos

```cmd
gvm install 1.21.0    # Instalar Go 1.21.0
gvm use 1.21.0        # Cambiar a Go 1.21.0  
gvm list              # Listar versiones instaladas
gvm listall           # Listar todas las versiones disponibles
gvm uninstall 1.20.5  # Desinstalar Go 1.20.5
```

## ✅ Características

- ✅ **Windows Only** - Optimizado específicamente para Windows
- ✅ **Instalación con una línea** (como NVM-Windows)
- ✅ **No requiere Go preinstalado**
- ✅ **Auto-configuración de PATH**
- ✅ **Integración con PowerShell y CMD**
- ✅ **Auto-switching con .go-version**
- ✅ **CI/CD automático**
- ✅ **Estructura limpia y mantenible**

---

**Listo para usar!** 🎉
