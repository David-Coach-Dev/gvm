/*
Copyright © 2020 NAME HERE <EMAIL ADDRESS>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package cmd

import (
	"fmt"
	"os"
	"os/exec"
	"time"

	"github.com/spf13/cobra"
)

func alreadyInstalled(gover string) bool {

	if gover == getSystemGoVer() {
		gover = systemGo
	}

	_, found := find(goVerList, gover)
	return found
}

func isExistRemote(gover string) bool {
	for _, ver := range getRemoteList() {
		if gover == ver {
			return true
		}
	}
	return false
}

func installOneVersion(version string) {
	installVersion := "go" + version
	installURL := "golang.org/dl/" + installVersion
	downloadExe := goPath + "\\bin\\" + installVersion + ".exe"

	// Validar formato de versión
	if !isGoVersionString(installVersion) {
		fmt.Printf("%s no tiene formato válido\n", makeColorString(colorRed, version))
		return
	}
	fmtV.Printf("%s tiene formato válido\n", makeColorString(colorGreen, version))

	// Verificar si ya está instalado
	if alreadyInstalled(installVersion) {
		fmt.Printf("%s ya está instalado\n", makeColorString(colorRed, installVersion))
		return
	}
	// Verificar si existe remotamente
	if !isExistRemote(installVersion) {
		fmt.Printf("%s no existe remotamente\n", makeColorString(colorRed, installVersion))
		return
	}

	fmtV.Printf("Iniciando instalación de %s\n--\n", installVersion)
	fmtV.Printf("URL de descarga: %s\n", installURL)
	fmtV.Printf("Descargando y ejecutando %s\n--\n", downloadExe)

	// Ejecutar comando de descarga
	getCmd := exec.Command("go", "install", installURL+"@latest")
	getCmd.Stdout = os.Stdout
	getCmd.Stderr = os.Stderr
	if err := getCmd.Run(); err != nil {
		fmt.Printf("Error ejecutando go get: %v\n", err)
		return
	}

	// Esperar a que el archivo se descargue
	timeoutSecond := 30
	elapsedSecond := 0
	for !fileExist(downloadExe) {
		fmtV.Printf("Aún no se instala %s.exe\n", installVersion)
		time.Sleep(1000 * time.Millisecond)
		elapsedSecond++
		if elapsedSecond >= timeoutSecond {
			fmt.Printf("Timeout al descargar el archivo. %d segundos\n", timeoutSecond)
			return
		}
	}
	fmtV.Printf("%s.exe instalado correctamente\n", installVersion)

	// Ejecutar comando para descargar el SDK
	fmt.Printf("Descargando SDK ejecutando %s.exe\n", installVersion)
	downloadCmd := exec.Command(downloadExe, "download")
	downloadCmd.Stdout = os.Stdout
	downloadCmd.Stderr = os.Stderr
	if err := downloadCmd.Run(); err != nil {
		fmt.Printf("Error ejecutando descarga de SDK: %v\n", err)
		return
	}
}

func install(cmd *cobra.Command, args []string) {

	noArgumentDisplayHelp(cmd, args)

	for _, ver := range args {
		installOneVersion(ver)
	}
}

// installCmd represents the install command
var installCmd = &cobra.Command{
	Use:   "install",
	Short: "Download and install your desired Go SDK version",
	Long: `Download and install any Go SDK version you want.
Just specify the version number without "go" prefix.

ex) $ gvm install 1.15.5 // install go v1.15.5

In detail, 
First, It installs go<version>.exe to "GOPATH\bin"
Second, It execute go<version>.exe, which will install SDK for the version. 
After then, when we execute go<version>.exe, it will run the installed go version.`,
	Run: install,
}

func init() {
	rootCmd.AddCommand(installCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// installCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// installCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
