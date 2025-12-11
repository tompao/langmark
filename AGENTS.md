# Benchmarks Implementation Guide

This document describes the two quicksort implementation variants used in this benchmark suite to help maintain consistency when adding new languages.

## Overview

Each language has two implementation files:
- `immutable.*` - Functional/immutable approach
- `in_place.*` - Imperative/in-place approach

## Immutable Implementation (`immutable.*`)

### Characteristics
- **Functional style**: Creates new arrays/vectors/slices instead of modifying existing ones
- **Recursion-based**: Uses recursion with base case and recursive calls
- **Data structures**: Creates temporary left/right partitions for elements smaller/larger than pivot

### Algorithm Structure
1. **Base case**: If array length ≤ 1, return the array as-is
2. **Pivot selection**: Use first element as pivot
3. **Partitioning**: Filter/iterate through remaining elements (excluding pivot):
   - Elements < pivot go to `left` array
   - Elements ≥ pivot go to `right` array
4. **Recursion**: Recursively sort `left` and `right`
5. **Combine**: Concatenate `sorted_left + [pivot] + sorted_right`

### Key Implementation Details
- No mutation of input array
- Returns a new sorted array
- May use functional operations like `filter()`, list comprehensions, or manual iteration
- Performance consideration: Pre-allocate space for left/right arrays when possible (e.g., `reserve()` in C++)

### Example Pattern (pseudocode)
```
function qsort(array):
    if length(array) <= 1:
        return array
    
    pivot = array[0]
    left = [x for x in array[1:] if x < pivot]
    right = [x for x in array[1:] if x >= pivot]
    
    return qsort(left) + [pivot] + qsort(right)
```

## In-Place Implementation (`in_place.*`)

### Characteristics
- **Imperative style**: Modifies the array in-place using swaps
- **Space-efficient**: O(1) extra space (excluding recursion stack)
- **Partition-based**: Uses Lomuto or Hoare partition scheme

### Algorithm Structure
1. **Main function**: Entry point that calls recursive helper with bounds
2. **Recursive helper** `qsort(array, lo, hi)`:
   - Base case: `lo >= hi`
   - Partition array and get pivot index
   - Recursively sort left and right partitions
3. **Partition function** `partition(array, lo, hi)`:
   - Choose pivot (typically last element)
   - Rearrange elements so smaller values come before pivot
   - Return final pivot position

### Partition Algorithm (Lomuto scheme)
1. Select `pivot = array[hi]` (last element)
2. Initialize `i = lo` (boundary between smaller and larger elements)
3. For each `j` from `lo` to `hi-1`:
   - If `array[j] < pivot`: swap `array[i]` with `array[j]`, increment `i`
4. Swap `array[i]` with `array[hi]` (place pivot in correct position)
5. Return `i` (pivot's final index)

### Key Implementation Details
- Modifies input array in-place
- No return value (void function) or returns the modified array
- Uses element swapping for rearrangement
- Requires low/high index parameters to track partition boundaries

### Example Pattern (pseudocode)
```
function quicksort(array):
    qsort(array, 0, length(array) - 1)

function qsort(array, lo, hi):
    if lo >= hi:
        return
    p = partition(array, lo, hi)
    qsort(array, lo, p - 1)
    qsort(array, p + 1, hi)

function partition(array, lo, hi):
    pivot = array[hi]
    i = lo
    for j from lo to hi-1:
        if array[j] < pivot:
            swap(array[i], array[j])
            i++
    swap(array[i], array[hi])
    return i
```

## Test Data Generation

All implementations must generate identical test data:
```
array[i] = (i * 73 + 19) % 10000
for i from 0 to 9999
```

This creates a reproducible pseudo-random sequence of 10,000 integers.

## Command-Line Flags

All implementations must support:
- **No flag**: Print first 10 elements of sorted result
- **`-v` (verbose)**: Print entire sorted array
- **`-p` (pre-print)**: Print entire unsorted array and exit (no sorting)

### Flag Implementation Pattern
1. Parse command-line arguments to detect flags
2. Generate test data
3. If `-p` flag: print unsorted array and exit
4. Perform sorting
5. If `-v` flag: print entire result, else print first 10 elements

## Adding a New Language

To add a new language to the benchmark:

1. **Create `immutable.<ext>`**:
   - Implement functional quicksort following the immutable pattern
   - Add flag parsing for `-v` and `-p`
   - Use the standard test data generation formula

2. **Create `in_place.<ext>`**:
   - Implement in-place quicksort with partition function
   - Add flag parsing for `-v` and `-p`
   - Use the standard test data generation formula

3. **Update `benchmark.v`**:
   - Add compilation command (if compiled language)
   - Add execution command to the list
   - Ensure build output goes to `build/` directory

4. **Update `shell.nix`** (if needed):
   - Add language toolchain to `buildInputs`
   - Add version info to `shellHook`

5. **Test**:
   - Run with `-p` flag to verify identical input data
   - Run with `-v` flag to verify correct sorting
   - Run benchmark to verify integration

## Performance Considerations

- **Immutable**: Generally slower due to memory allocations; optimize by:
  - Pre-allocating array capacity where supported
  - Minimizing copies/allocations during concatenation
  
- **In-place**: Generally faster due to cache locality and no allocations:
  - Memory access patterns are more predictable
  - No garbage collection pressure

- **Compilation**: Use optimization flags:
  - C++: `-O3 -march=native`
  - Go: default optimizations in compiled binaries
  - OCaml: `ocamlopt` (native code compiler)
  - Rust: `-C opt-level=3 -C target-cpu=native`
  - V: `-prod` flag

