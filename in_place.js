function partition(arr, lo, hi) {
    const pivot = arr[hi];
    let i = lo;
    
    for (let j = lo; j < hi; j++) {
        if (arr[j] < pivot) {
            [arr[i], arr[j]] = [arr[j], arr[i]];
            i++;
        }
    }
    
    [arr[i], arr[hi]] = [arr[hi], arr[i]];
    return i;
}

function qsort(arr, lo, hi) {
    if (lo >= hi) {
        return;
    }
    
    const p = partition(arr, lo, hi);
    qsort(arr, lo, p - 1);
    qsort(arr, p + 1, hi);
}

function quicksort(arr) {
    if (arr.length > 0) {
        qsort(arr, 0, arr.length - 1);
    }
}

function main() {
    const args = process.argv.slice(2);
    const verbose = args.includes('-v');
    const prePrint = args.includes('-p');
    
    // Generate test data
    const xs = Array.from({length: 10000}, (_, i) => (i * 73 + 19) % 10000);
    
    if (prePrint) {
        console.log('Before sorting:');
        console.log(JSON.stringify(xs));
        return;
    }
    
    quicksort(xs);
    
    if (verbose) {
        console.log(JSON.stringify(xs));
    } else {
        console.log(JSON.stringify(xs.slice(0, 10)));
    }
}

main();
