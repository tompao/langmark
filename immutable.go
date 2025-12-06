package main

import (
	"fmt"
	"os"
)

func qsort(xs []int) []int {
	if len(xs) <= 1 {
		return xs
	}

	pivot := xs[0]
	left := []int{}
	right := []int{}

	for _, x := range xs[1:] {
		if x < pivot {
			left = append(left, x)
		} else {
			right = append(right, x)
		}
	}

	result := qsort(left)
	result = append(result, pivot)
	result = append(result, qsort(right)...)
	return result
}

func main() {
	verbose := false
	prePrint := false
	for _, arg := range os.Args[1:] {
		if arg == "-v" {
			verbose = true
		} else if arg == "-p" {
			prePrint = true
		}
	}
	xs := make([]int, 10000)
	for i := 0; i < 10000; i++ {
		xs[i] = (i*73 + 19) % 10000
	}
	if prePrint {
		fmt.Println("Before sorting:")
		fmt.Println(xs)
		return
	}
	result := qsort(xs)
	if verbose {
		fmt.Println(result)
	} else {
		fmt.Println(result[:10])
	}
}
