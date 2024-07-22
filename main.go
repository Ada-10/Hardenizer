package main

import (
	"fmt"
	"os"
	"text/template"

	"gopkg.in/yaml.v3"
)

type RegistryInfo struct {
	TestName string `yaml:"test_name"`
	Path     string `yaml:"path"`
	Name     string `yaml:"name"`
	Value    int    `yaml:"value"`
}
type Data struct {
	Product_key string
	Tests       struct {
		System_Test []RegistryInfo `yaml:"system_tests"`
		User_Test   []RegistryInfo `yaml:"user_tests"`
	} `yaml:"tests"`
}

type Unattend_data struct {
	ProductKey   string
	SystemScript string
	UserScript   string
}

func main() {
	yml_data := Data{}
	// Reading Files
	yml, readErr := os.ReadFile("./tests.yml")
	if readErr != nil {
		fmt.Println("Can't read test file")
		panic(readErr)
	}
	//	system_script, err := os.ReadFile("system.ps1")
	//	if err != nil {
	//		panic(err)
	//	}
	script, err := os.ReadFile("./templates/hardening_template.ps1")
	if err != nil {
		panic(err)
	}
	unmarshalErr := yaml.Unmarshal(yml, &yml_data)
	if unmarshalErr != nil {
		panic(unmarshalErr)
	}
	t := template.Must(template.New("harden_script").Parse(string(script)))

	system_file, err := os.Create("./scripts/system.ps1")
	if err != nil {
		panic(err)
	}
	user_file, err := os.Create("./scripts/user.ps1")
	if err != nil {
		panic(err)
	}

	userErr := t.Execute(system_file, yml_data.Tests.System_Test)
	if userErr != nil {
		panic(userErr)
	}

	templateErr := t.Execute(user_file, yml_data.Tests.User_Test)
	if templateErr != nil {
		panic(templateErr)
	}

	//Template unattend.xml
	file, err := os.Create("./scripts/autounattend.xml")
	if err != nil {
		panic(err)
	}
	unattend_template, err := os.ReadFile("./templates/autounattend_template.xml")
	if err != nil {
		panic(err)
	}

	system_script, err := os.ReadFile("./scripts/system.ps1")
	if err != nil {
		panic(err)
	}
	user_script, err := os.ReadFile("./scripts/user.ps1")
	if err != nil {
		panic(err)
	}
	data := Unattend_data{
		ProductKey:   yml_data.Product_key,
		SystemScript: string(system_script),
		UserScript:   string(user_script),
	}
	t = template.Must(template.New("unattend_template").Parse(string(unattend_template)))
	finalerr := t.Execute(file, data)
	if finalerr != nil {
		fmt.Println(err)
	}
}
