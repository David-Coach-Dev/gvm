# GVM - Go Version Manager

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
│   └── release.yml               # Build y release automático
│
├── 🚀 install-nvm-style.ps1      # Instalador PowerShell (principal)
├── 🚀 install.sh                 # Instalador Bash (Linux/macOS)  
├── 🚀 install-gvm.bat            # Instalador CMD (Windows)
├── 🔧 build.ps1                  # Build script PowerShell
└── 🔧 build.sh                   # Build script Bash
```

## 🎯 Archivos Principales

### **Instaladores (Estilo NVM)**
- `install-nvm-style.ps1` - Instalador principal para Windows PowerShell
- `install.sh` - Instalador para Linux/macOS con Bash  
- `install-gvm.bat` - Instalador alternativo para CMD Windows

### **Código Fuente**
- `main.go` - Punto de entrada, configuración CLI con Cobra
- `cmd/*.go` - Implementación de todos los comandos

### **Automatización**
- `.github/workflows/release.yml` - CI/CD para builds automáticos
- `build.ps1` / `build.sh` - Scripts de build local

## 🚀 Uso Rápido

### Instalación One-liner
```powershell
# PowerShell (Recomendado)
iwr -useb https://raw.githubusercontent.com/David-Coach-Dev/gvm/main/install-nvm-style.ps1 | iex

# Bash (Linux/macOS)  
curl -o- https://raw.githubusercontent.com/David-Coach-Dev/gvm/main/install.sh | bash

# CMD (Windows)
curl -o install-gvm.bat https://raw.githubusercontent.com/David-Coach-Dev/gvm/main/install-gvm.bat && install-gvm.bat
```

### Comandos Básicos
```bash
gvm install 1.21.0    # Instalar Go 1.21.0
gvm use 1.21.0        # Cambiar a Go 1.21.0  
gvm list              # Listar versiones instaladas
gvm listall           # Listar todas las versiones disponibles
gvm uninstall 1.20.5  # Desinstalar Go 1.20.5
```

## ✅ Características

- ✅ **Instalación con una línea** (como NVM)
- ✅ **No requiere Go preinstalado**
- ✅ **Cross-platform** (Windows, Linux, macOS)
- ✅ **Auto-configuración de PATH**
- ✅ **Integración con shell**
- ✅ **Auto-switching con .go-version**
- ✅ **CI/CD automático**
- ✅ **Estructura limpia y mantenible**

---

**Listo para usar!** 🎉
