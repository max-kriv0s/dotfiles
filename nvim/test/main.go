package main

import "fmt"

func sum(numbers []int) int {
	total := 0
	for _, n := range numbers {
		total += n
	}
	return total
}

func main() {
	numbers := []int{1, 2, 3, 4, 5}
	fmt.Println(sum(numbers))
}
