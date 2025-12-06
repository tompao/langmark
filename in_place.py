def quicksort(a, lo=0, hi=None):
    if hi is None:
        hi = len(a) - 1
    if lo >= hi:
        return

    p = partition(a, lo, hi)
    quicksort(a, lo, p - 1)
    quicksort(a, p + 1, hi)


def partition(a, lo, hi):
    pivot = a[hi]
    i = lo
    for j in range(lo, hi):
        if a[j] < pivot:
            a[i], a[j] = a[j], a[i]
            i += 1
    a[i], a[hi] = a[hi], a[i]
    return i


if __name__ == "__main__":
    import sys
    verbose = '-v' in sys.argv
    pre_print = '-p' in sys.argv
    xs = [(i * 73 + 19) % 10000 for i in range(10000)]
    if pre_print:
        print('Before sorting:')
        print(xs)
        sys.exit(0)
    quicksort(xs)
    if verbose:
        print(xs)
    else:
        print(xs[:10])
