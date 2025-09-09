package cmd

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/spf13/cobra"
)

// demoInstall simula la instalación de una versión de Go
func demoInstall(cmd *cobra.Command, args []string) {
	if len(args) == 0 {
		fmt.Println("Uso: gvm demo-install <version>")
		fmt.Println("Ejemplo: gvm demo-install 1.21.0")
		return
	}

	version := args[0]
	fmt.Printf("🚀 Simulando instalación de Go %s...\n", version)

	// Simular estructura de directorios
	homeDir, _ := os.UserHomeDir()
	gvmDir := filepath.Join(homeDir, "AppData", "Local", "gvm")
	versionDir := filepath.Join(gvmDir, "versions", version)

	fmt.Printf("📁 Creando directorio: %s\n", versionDir)
	os.MkdirAll(versionDir, 0755)

	fmt.Printf("🔄 Descargando Go %s desde golang.org...\n", version)
	fmt.Println("📦 Extrayendo archivos...")
	fmt.Println("🔗 Configurando enlaces...")
	fmt.Println("🎯 Actualizando variables de entorno...")

	// Crear archivo de marcador
	markerFile := filepath.Join(versionDir, "installed.txt")
	os.WriteFile(markerFile, []byte(fmt.Sprintf("Go %s installed at %s", version, versionDir)), 0644)

	fmt.Printf("✅ Go %s instalado exitosamente\n", version)
	fmt.Printf("💡 Usa 'gvm demo-use %s' para activar esta versión\n", version)
}

// demoUse simula el cambio a una versión específica
func demoUse(cmd *cobra.Command, args []string) {
	if len(args) == 0 {
		fmt.Println("Uso: gvm demo-use <version>")
		fmt.Println("Ejemplo: gvm demo-use 1.21.0")
		return
	}

	version := args[0]
	homeDir, _ := os.UserHomeDir()
	versionDir := filepath.Join(homeDir, "AppData", "Local", "gvm", "versions", version)
	markerFile := filepath.Join(versionDir, "installed.txt")

	if _, err := os.Stat(markerFile); os.IsNotExist(err) {
		fmt.Printf("❌ Go %s no está instalado\n", version)
		fmt.Printf("💡 Ejecuta 'gvm demo-install %s' primero\n", version)
		return
	}

	fmt.Printf("🔄 Cambiando a Go %s...\n", version)
	fmt.Println("🎯 Actualizando PATH...")
	fmt.Println("🔗 Configurando GOROOT...")
	fmt.Println("✅ Ahora usando Go " + version)

	// Simular salida de go version
	fmt.Printf("\n$ go version\n")
	fmt.Printf("go version go%s windows/amd64\n", version)
}

// demoList simula el listado de versiones instaladas
func demoList(cmd *cobra.Command, args []string) {
	homeDir, _ := os.UserHomeDir()
	versionsDir := filepath.Join(homeDir, "AppData", "Local", "gvm", "versions")

	fmt.Println("Versiones de Go instaladas:")

	entries, err := os.ReadDir(versionsDir)
	if err != nil {
		fmt.Println("  (ninguna versión instalada)")
		return
	}

	if len(entries) == 0 {
		fmt.Println("  (ninguna versión instalada)")
		return
	}

	for i, entry := range entries {
		if entry.IsDir() {
			marker := "  "
			if i == 0 { // Simular que la primera es la activa
				marker = "* "
			}
			fmt.Printf("%s go%s\n", marker, entry.Name())
		}
	}
}

// Comandos de demostración
var demoInstallCmd = &cobra.Command{
	Use:   "demo-install",
	Short: "Simula la instalación de una versión de Go (demostración)",
	Long:  `Comando de demostración que simula cómo funcionaría la instalación real de Go sin requerir Go pre-instalado.`,
	Run:   demoInstall,
}

var demoUseCmd = &cobra.Command{
	Use:   "demo-use",
	Short: "Simula el cambio a una versión de Go (demostración)",
	Long:  `Comando de demostración que simula cómo funcionaría el cambio de versión real.`,
	Run:   demoUse,
}

var demoListCmd = &cobra.Command{
	Use:   "demo-list",
	Short: "Simula el listado de versiones instaladas (demostración)",
	Long:  `Comando de demostración que simula cómo funcionaría el listado real.`,
	Run:   demoList,
}

func init() {
	rootCmd.AddCommand(demoInstallCmd)
	rootCmd.AddCommand(demoUseCmd)
	rootCmd.AddCommand(demoListCmd)
}
