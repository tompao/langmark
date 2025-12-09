import os
import time

struct BenchResult {
	name string
	time_ms f64
	worst_time_ms f64
}

fn run_command_once(cmd string) !f64 {
	start := time.now()
	result := os.execute(cmd)
	elapsed := time.since(start)
	
	if result.exit_code != 0 {
		return error('Failed to run ${cmd}: ${result.output}')
	}
	
	return f64(elapsed) / time.millisecond
}

fn run_command(cmd string, iterations int) !BenchResult {
	mut best_time := f64(0)
	mut worst_time := f64(0)
	
	for i in 0 .. iterations {
		time_ms := run_command_once(cmd)!
		if i == 0 || time_ms < best_time {
			best_time = time_ms
		}
		if i == 0 || time_ms > worst_time {
			worst_time = time_ms
		}
	}
	
	return BenchResult{
		name: cmd
		time_ms: best_time
		worst_time_ms: worst_time
	}
}

fn verify_consistency(all_commands []string, extra_args string) bool {
	println('\nVerifying consistency across implementations...\n')
	
	// Normalize output by removing all formatting characters
	normalize := fn (s string) string {
		return s.replace(' ', '').replace(',', '').replace('[', '').replace(']', '').trim_space()
	}
	
	// Test with -p flag (pre-print unsorted array)
	println('Testing input generation (-p flag):')
	mut reference_output := ''
	mut all_match := true
	
	for cmd in all_commands {
		test_cmd := '${cmd} -p'
		result := os.execute(test_cmd)
		if result.exit_code != 0 {
			eprintln('  ✗ ${cmd}: Failed to run')
			all_match = false
			continue
		}
		normalized := normalize(result.output)
		if reference_output == '' {
			reference_output = normalized
			println('  ✓ ${cmd} (reference)')
		} else if normalized == reference_output {
			println('  ✓ ${cmd}')
		} else {
			println('  ✗ ${cmd}: Output differs from reference')
			all_match = false
		}
	}
	
	if !all_match {
		eprintln('\nERROR: Not all implementations produce the same input!')
		return false
	}
	
	// Test default output (first 10 elements)
	println('\nTesting sorted output (-v flag):')
	reference_output = ''
	all_match = true
	
	for cmd in all_commands {
		test_cmd := '${cmd} -v'
		result := os.execute(test_cmd)
		if result.exit_code != 0 {
			eprintln('  ✗ ${cmd}: Failed to run')
			all_match = false
			continue
		}
		normalized := normalize(result.output)
		if reference_output == '' {
			reference_output = normalized
			println('  ✓ ${cmd} (reference)')
		} else if normalized == reference_output {
			println('  ✓ ${cmd}')
		} else {
			println('  ✗ ${cmd}: Output differs from reference')
			all_match = false
		}
	}
	
	if !all_match {
		eprintln('\nERROR: Not all implementations produce the same output!')
		return false
	}
	
	println('\n✓ All implementations verified!\n')
	return true
}

fn main() {
	// Collect command line arguments to pass to all programs
	mut extra_args := ''
	for arg in os.args[1..] {
		extra_args += ' ${arg}'
	}
	
	println('Building programs...\n')
	
	// Create build directory
	os.mkdir_all('build') or {
		eprintln('Failed to create build directory')
		return
	}
	
	// Build C++ programs
	println('Compiling C++...')
	cpp_immutable_build := os.execute('g++ -O3 -march=native -o build/immutable_cpp immutable.cpp')
	cpp_inplace_build := os.execute('g++ -O3 -march=native -o build/in_place_cpp in_place.cpp')
	
	if cpp_immutable_build.exit_code != 0 {
		eprintln('Failed to compile immutable.cpp')
	}
	if cpp_inplace_build.exit_code != 0 {
		eprintln('Failed to compile in_place.cpp')
	}
	
	// Build Go programs
	println('Compiling Go...')
	go_immutable_build := os.execute('go build -o build/immutable_go immutable.go')
	go_inplace_build := os.execute('go build -o build/in_place_go in_place.go')
	
	if go_immutable_build.exit_code != 0 {
		eprintln('Failed to compile immutable.go')
	}
	if go_inplace_build.exit_code != 0 {
		eprintln('Failed to compile in_place.go')
	}
	
	// Build V programs
	println('Compiling V...')
	v_immutable_build := os.execute('v -prod -o build/immutable_v immutable.v')
	v_inplace_build := os.execute('v -prod -o build/in_place_v in_place.v')
	
	if v_immutable_build.exit_code != 0 {
		eprintln('Failed to compile immutable.v')
	}
	if v_inplace_build.exit_code != 0 {
		eprintln('Failed to compile in_place.v')
	}
	
	// Build OCaml programs
	println('Compiling OCaml...')
	ocaml_immutable_build := os.execute('ocamlopt -o build/immutable_ml immutable.ml && mv immutable.cmi immutable.cmx immutable.o build/ 2>/dev/null || true')
	ocaml_inplace_build := os.execute('ocamlopt -o build/in_place_ml in_place.ml && mv in_place.cmi in_place.cmx in_place.o build/ 2>/dev/null || true')
	
	if ocaml_immutable_build.exit_code != 0 {
		eprintln('Failed to compile immutable.ml')
	}
	if ocaml_inplace_build.exit_code != 0 {
		eprintln('Failed to compile in_place.ml')
	}
	
	// Build Rust programs
	println('Compiling Rust...')
	rust_immutable_build := os.execute('rustc -C opt-level=3 -C target-cpu=native -o build/immutable_rust immutable.rs')
	rust_inplace_build := os.execute('rustc -C opt-level=3 -C target-cpu=native -o build/in_place_rust in_place.rs')
	
	if rust_immutable_build.exit_code != 0 {
		eprintln('Failed to compile immutable.rs')
	}
	if rust_inplace_build.exit_code != 0 {
		eprintln('Failed to compile in_place.rs')
	}
	
	// Commands to run (Python and JavaScript are interpreted, others are compiled binaries)
	mut all_commands := [
		'python3 immutable.py',
		'python3 in_place.py',
		'node immutable.js',
		'node in_place.js',
	]
	
	if cpp_immutable_build.exit_code == 0 {
		all_commands << './build/immutable_cpp'
	}
	if cpp_inplace_build.exit_code == 0 {
		all_commands << './build/in_place_cpp'
	}
	if go_immutable_build.exit_code == 0 {
		all_commands << './build/immutable_go'
	}
	if go_inplace_build.exit_code == 0 {
		all_commands << './build/in_place_go'
	}
	if v_immutable_build.exit_code == 0 {
		all_commands << './build/immutable_v'
	}
	if v_inplace_build.exit_code == 0 {
		all_commands << './build/in_place_v'
	}
	if ocaml_immutable_build.exit_code == 0 {
		all_commands << './build/immutable_ml'
	}
	if ocaml_inplace_build.exit_code == 0 {
		all_commands << './build/in_place_ml'
	}
	if rust_immutable_build.exit_code == 0 {
		all_commands << './build/immutable_rust'
	}
	if rust_inplace_build.exit_code == 0 {
		all_commands << './build/in_place_rust'
	}
	
	// Verify all implementations produce the same output
	if !verify_consistency(all_commands, extra_args) {
		return
	}
	
	// Run benchmarks
	iterations := 10
	mut results := []BenchResult{}
	
	println('\nRunning benchmarks (${iterations} iterations each, best time kept)...\n')
	
	for cmd in all_commands {
		full_cmd := cmd + extra_args
		print('Running ${full_cmd}... ')
		result := run_command(full_cmd, iterations) or {
			eprintln('ERROR: ${err}')
			continue
		}
		println('✓ (best: ${result.time_ms:.2f} ms, worst: ${result.worst_time_ms:.2f} ms)')
		results << result
	}
	
	// Sort by time
	results.sort(a.time_ms < b.time_ms)
	
	// Print results table
	println('\n' + '='.repeat(50))
	println('Benchmark Results (sorted by execution time)')
	println('='.repeat(50))
	//println('${' Rank':-6} ${'Implementation':-25} ${'Time (ms)':>12}')
	println('-'.repeat(50))
	
	for i, result in results {
		rank := '${i + 1}.'
		//println('${rank:-6} ${result.name:-25} ${result.time_ms:>12.2f}')
		println('${rank} ${result.name} ${result.time_ms} ms')
	}
	
	println('='.repeat(50))
}
