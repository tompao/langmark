let swap arr i j =
  let temp = arr.(i) in
  arr.(i) <- arr.(j);
  arr.(j) <- temp

let partition arr lo hi =
  let pivot = arr.(hi) in
  let i = ref lo in
  for j = lo to hi - 1 do
    if arr.(j) < pivot then (
      swap arr !i j;
      incr i
    )
  done;
  swap arr !i hi;
  !i

let rec qsort arr lo hi =
  if lo < hi then (
    let p = partition arr lo hi in
    qsort arr lo (p - 1);
    qsort arr (p + 1) hi
  )

let quicksort arr =
  if Array.length arr > 0 then
    qsort arr 0 (Array.length arr - 1)

let () =
  let verbose = Array.mem "-v" Sys.argv in
  let pre_print = Array.mem "-p" Sys.argv in
  
  (* Generate test data *)
  let xs = Array.init 10000 (fun i -> (i * 73 + 19) mod 10000) in
  
  if pre_print then (
    print_endline "Before sorting:";
    print_string "[";
    Array.iteri (fun i x ->
      if i > 0 then print_string ", ";
      print_int x
    ) xs;
    print_endline "]"
  ) else (
    quicksort xs;
    if verbose then (
      print_string "[";
      Array.iteri (fun i x ->
        if i > 0 then print_string ", ";
        print_int x
      ) xs;
      print_endline "]"
    ) else (
      print_string "[";
      for i = 0 to 9 do
        if i > 0 then print_string ", ";
        print_int xs.(i)
      done;
      print_endline "]"
    )
  )
