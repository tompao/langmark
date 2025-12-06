def qsort(xs):
    if len(xs) <= 1:
        return xs
    pivot = xs[0]
    left = [x for x in xs[1:] if x < pivot]
    right = [x for x in xs[1:] if x >= pivot]
    return qsort(left) + [pivot] + qsort(right)

if __name__ == "__main__":
    import sys
    verbose = '-v' in sys.argv
    pre_print = '-p' in sys.argv
    xs = [(i * 73 + 19) % 10000 for i in range(10000)]
    if pre_print:
        print('Before sorting:')
        print(xs)
        sys.exit(0)
    result = qsort(xs)
    if verbose:
        print(result)
    else:
        print(result[:10])
