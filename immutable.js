function qsort(xs) {
    if (xs.length <= 1) {
        return xs;
    }
    
    const pivot = xs[0];
    const left = xs.slice(1).filter(x => x < pivot);
    const right = xs.slice(1).filter(x => x >= pivot);
    
    return [...qsort(left), pivot, ...qsort(right)];
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
    
    const result = qsort(xs);
    
    if (verbose) {
        console.log(JSON.stringify(result));
    } else {
        console.log(JSON.stringify(result.slice(0, 10)));
    }
}

main();
