package cmd

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"runtime"
	"strings"

	"github.com/spf13/cobra"
)

// downloadGoVersion descarga una versión específica de Go desde el sitio oficial
func downloadGoVersion(version string) error {
	// Construir URL de descarga
	goArch := runtime.GOARCH
	goOS := runtime.GOOS

	// Formatear versión (agregar 'go' si no lo tiene)
	if !strings.HasPrefix(version, "go") {
		version = "go" + version
	}

	// URL del archivo a descargar
	fileName := fmt.Sprintf("%s.%s-%s.zip", version, goOS, goArch)
	if goOS == "windows" {
		fileName = fmt.Sprintf("%s.%s-%s.zip", version, goOS, goArch)
	}

	downloadURL := fmt.Sprintf("https://golang.org/dl/%s", fileName)

	fmt.Printf("Descargando %s desde %s\n", version, downloadURL)

	// Crear directorio de destino
	versionDir := filepath.Join(goPath, "versions", version)
	if err := os.MkdirAll(versionDir, 0755); err != nil {
		return fmt.Errorf("error creando directorio %s: %v", versionDir, err)
	}

	// Descargar archivo
	resp, err := http.Get(downloadURL)
	if err != nil {
		return fmt.Errorf("error descargando: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return fmt.Errorf("error HTTP %d: versión %s no encontrada", resp.StatusCode, version)
	}

	// Guardar archivo
	zipPath := filepath.Join(versionDir, fileName)
	file, err := os.Create(zipPath)
	if err != nil {
		return fmt.Errorf("error creando archivo: %v", err)
	}
	defer file.Close()

	_, err = io.Copy(file, resp.Body)
	if err != nil {
		return fmt.Errorf("error guardando archivo: %v", err)
	}

	fmt.Printf("Descarga completada: %s\n", zipPath)

	// Extraer archivo (implementar descompresión)
	if err := extractGoArchive(zipPath, versionDir); err != nil {
		return fmt.Errorf("error extrayendo archivo: %v", err)
	}

	// Crear enlace simbólico o copiar binario a la carpeta bin
	goBinSrc := filepath.Join(versionDir, "go", "bin", "go.exe")
	goBinDst := filepath.Join(goPath, "bin", version+".exe")

	if err := copyFile(goBinSrc, goBinDst); err != nil {
		return fmt.Errorf("error copiando binario: %v", err)
	}

	fmt.Printf("Versión %s instalada exitosamente\n", version)
	return nil
}

// extractGoArchive extrae el archivo zip de Go
func extractGoArchive(zipPath, destDir string) error {
	// Implementar extracción de ZIP
	// Por simplicidad, usar comando del sistema por ahora
	cmd := fmt.Sprintf(`powershell -Command "Expand-Archive -Path '%s' -DestinationPath '%s' -Force"`, zipPath, destDir)

	if err := executeCommand(cmd); err != nil {
		return err
	}

	// Eliminar archivo zip después de extraer
	os.Remove(zipPath)
	return nil
}

// installBootstrap instala una versión de Go descargando desde el sitio oficial
func installBootstrap(cmd *cobra.Command, args []string) {
	if len(args) == 0 {
		fmt.Println("Uso: gvm install <version>")
		fmt.Println("Ejemplo: gvm install 1.21.0")
		return
	}

	version := args[0]

	// Verificar si ya está instalada
	if alreadyInstalled("go"+version) {
		fmt.Printf("La versión go%s ya está instalada\n", version)
		return
	}

	// Descargar e instalar
	if err := downloadGoVersion(version); err != nil {
		fmt.Printf("Error instalando versión %s: %v\n", version, err)
		return
	}

	fmt.Printf("Versión go%s instalada. Usa 'gvm use %s' para activarla.\n", version, version)
}

// installBootstrapCmd representa el comando de instalación bootstrap
var installBootstrapCmd = &cobra.Command{
	Use:   "install",
	Short: "Descarga e instala una versión de Go desde el sitio oficial",
	Long: `Descarga e instala una versión específica de Go directamente desde golang.org.
No requiere tener Go previamente instalado.

Ejemplo:
  gvm install 1.21.0
  gvm install 1.20.7`,
	Run: installBootstrap,
}

func init() {
	rootCmd.AddCommand(installBootstrapCmd)
}
