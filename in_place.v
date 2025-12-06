import os

fn quicksort(mut a []int) {
    if a.len <= 1 {
        return
    }
    qsort(mut a, 0, a.len - 1)
}

fn qsort(mut a []int, lo int, hi int) {
    if lo >= hi {
        return
    }
    p := partition(mut a, lo, hi)
    qsort(mut a, lo, p - 1)
    qsort(mut a, p + 1, hi)
}

fn partition(mut a []int, lo int, hi int) int {
    pivot := a[hi]
    mut i := lo
    for j in lo .. hi {
        if a[j] < pivot {
            a[i], a[j] = a[j], a[i]
            i++
        }
    }
    a[i], a[hi] = a[hi], a[i]
    return i
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
    quicksort(mut xs)
    if verbose {
        println(xs)
    } else {
        println(xs[..10])
    }
}
