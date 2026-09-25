// LSP: gopls. Форматирование: goimports. Линтер: golangci-lint.
// Проверять: отступы табами (:echo &expandtab -> 0), gd, <leader>uh

package main

import "fmt"

type User struct {
	ID     int
	Name   string
	Active bool
}

func ActiveNames(users []User) []string {
	names := make([]string, 0, len(users))

	for _, user := range users {
		if user.Active {
			names = append(names, user.Name)
		}
	}

	return names
}

func main() {
	users := []User{
		{ID: 1, Name: "Мария", Active: true},
		{ID: 2, Name: "Иван", Active: false},
	}

	fmt.Println(ActiveNames(users))
}
