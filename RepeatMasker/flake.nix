{
  description = "Nix flake for RepeatMasker";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in {
      packages.x86_64-linux.default = pkgs.callPackage ./default.nix { };

      devShell.x86_64-linux = pkgs.mkShell {
        buildInputs = [
          (pkgs.callPackage ./default.nix { })
        ];
      };
    };
}