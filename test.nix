{

  description = "test flake for kraken2";

  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {self, nixpkgs, flake-utils}:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        (
          { lib, stdenv, fetchUrl, rsync, perl, wget, gnused, findutils, libgcc }: 

          stdenv.mkDerivation rec {
            pname = "kraken2";
            version = "2.1.4";

            src = fetchfromGithub {
              owner = "";
              repo = "";
              rev = "v${version}";
              sha256 = "0mvqhlqax373r3l4c9jpq8dsg8xkxp4nv4mx8ivhs9gh1wnmk6ki";
            };

            buildInputs = [
              rsync
              perl
              wget
              gnused
              findutils
              libgcc
            ];

            meta = with lib; {
              description = "The second version of the Kraken taxonomic sequence classification system";
              homepage ="https://ccb.jhu.edu/software/kraken2/";
              license = licenses.mit;
            };
          }
        );
      }
    )
  
}