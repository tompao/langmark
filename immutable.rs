use std::env;

fn quicksort(arr: &[i32]) -> Vec<i32> {
    if arr.len() <= 1 {
        return arr.to_vec();
    }
    
    let pivot = arr[0];
    let mut left = Vec::new();
    let mut right = Vec::new();
    
    // Pre-allocate capacity for better performance
    left.reserve(arr.len() / 2);
    right.reserve(arr.len() / 2);
    
    for &x in &arr[1..] {
        if x < pivot {
            left.push(x);
        } else {
            right.push(x);
        }
    }
    
    let mut sorted_left = quicksort(&left);
    sorted_left.push(pivot);
    sorted_left.extend(quicksort(&right));
    sorted_left
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
    
    let sorted = quicksort(&arr);
    
    if verbose {
        println!("{:?}", sorted);
    } else {
        println!("{:?}", &sorted[..10]);
    }
}
