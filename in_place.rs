use std::env;

fn quicksort(arr: &mut [i32], lo: isize, hi: isize) {
    if lo >= hi || lo < 0 {
        return;
    }
    
    let p = partition(arr, lo, hi);
    quicksort(arr, lo, p - 1);
    quicksort(arr, p + 1, hi);
}

fn partition(arr: &mut [i32], lo: isize, hi: isize) -> isize {
    let pivot = arr[hi as usize];
    let mut i = lo;
    
    for j in lo..hi {
        if arr[j as usize] < pivot {
            arr.swap(i as usize, j as usize);
            i += 1;
        }
    }
    
    arr.swap(i as usize, hi as usize);
    i
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let verbose = args.contains(&String::from("-v"));
    let pre_print = args.contains(&String::from("-p"));
    
    // Generate test data
    let mut arr = Vec::with_capacity(10000);
    for i in 0..10000 {
        arr.push((i * 73 + 19) % 10000);
    }
    
    if pre_print {
        println!("Before sorting:");
        println!("{:?}", arr);
        return;
    }
    
    let len = arr.len() as isize;
    quicksort(&mut arr, 0, len - 1);
    
    if verbose {
        println!("{:?}", arr);
    } else {
        println!("{:?}", &arr[..10]);
    }
}
