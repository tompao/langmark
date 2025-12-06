{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    git

    # Go
    go
    gopls
    gotools
    go-tools
    
    # V
    vlang
    
    # C++
    gcc
    clang
    cmake
    gnumake
    
    # Python
    python3
    python311Packages.pip
    python311Packages.virtualenv
    
    # OCaml
    ocaml
    opam
    
    # JavaScript (Node.js)
    nodejs
  ];

  shellHook = ''
    echo "Development environment loaded!"
    echo "Available languages:"
    echo "  - Go: $(go version)"
    echo "  - V: $(v version)"
    echo "  - C++: $(g++ --version | head -n1)"
    echo "  - Python: $(python3 --version)"
    echo "  - OCaml: $(ocaml -version)"
    echo "  - Node.js: $(node --version)"
  '';
}
