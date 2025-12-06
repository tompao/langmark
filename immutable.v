import os

fn qsort(xs []int) []int {
	if xs.len <= 1 {
		return xs
	}
	pivot := xs[0]
	left := xs[1..].filter(it < pivot)
	right := xs[1..].filter(it >= pivot)
	mut result := qsort(left)
	result << pivot
	result << qsort(right)
	return result
}

fn main() {
    verbose := '-v' in os.args
    pre_print := '-p' in os.args
	mut xs := []int{len: 10000}
	for i in 0 .. 10000 {
		xs[i] = (i * 73 + 19) % 10000
	}
	if pre_print {
		println('Before sorting:')
		println(xs)
		return
	}
	result := qsort(xs)
	if verbose {
		println(result)
	} else {
		println(result[..10])
	}
}
