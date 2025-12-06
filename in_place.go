package main

import (
	"fmt"
	"os"
)

func quicksort(a []int) {
	if len(a) <= 1 {
		return
	}
	qsort(a, 0, len(a)-1)
}

func qsort(a []int, lo, hi int) {
	if lo >= hi {
		return
	}
	p := partition(a, lo, hi)
	qsort(a, lo, p-1)
	qsort(a, p+1, hi)
}

func partition(a []int, lo, hi int) int {
	pivot := a[hi]
	i := lo
	for j := lo; j < hi; j++ {
		if a[j] < pivot {
			a[i], a[j] = a[j], a[i]
			i++
		}
	}
	a[i], a[hi] = a[hi], a[i]
	return i
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
	quicksort(xs)
	if verbose {
		fmt.Println(xs)
	} else {
		fmt.Println(xs[:10])
	}
}
