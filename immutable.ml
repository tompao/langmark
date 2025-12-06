let rec qsort = function
  | [] -> []
  | [x] -> [x]
  | pivot :: rest ->
      let left = List.filter (fun x -> x < pivot) rest in
      let right = List.filter (fun x -> x >= pivot) rest in
      qsort left @ [pivot] @ qsort right

let () =
  let verbose = Array.mem "-v" Sys.argv in
  let pre_print = Array.mem "-p" Sys.argv in
  
  (* Generate test data *)
  let xs = Array.init 10000 (fun i -> (i * 73 + 19) mod 10000) in
  let xs_list = Array.to_list xs in
  
  if pre_print then (
    print_endline "Before sorting:";
    print_string "[";
    List.iteri (fun i x ->
      if i > 0 then print_string ", ";
      print_int x
    ) xs_list;
    print_endline "]"
  ) else (
    let result = qsort xs_list in
    if verbose then (
      print_string "[";
      List.iteri (fun i x ->
        if i > 0 then print_string ", ";
        print_int x
      ) result;
      print_endline "]"
    ) else (
      let first_10 = List.filteri (fun i _ -> i < 10) result in
      print_string "[";
      List.iteri (fun i x ->
        if i > 0 then print_string ", ";
        print_int x
      ) first_10;
      print_endline "]"
    )
  )
