{ lib, stdenv, fetchFromGitHub, rsync, perl, wget, gnused, findutils, libgcc, llvmPackages, zlib }: 

stdenv.mkDerivation rec {
  pname = "kraken2";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "DerrickWood";
    repo = "kraken2";
    rev = "v2.14";
    sha256 = "sha256-PneYibG7/u1M32f1irvBwUWyrE4gBL3evVCSj94YGQM=";
  };

  buildInputs = [
    rsync
    perl
    wget
    gnused
    findutils
    libgcc
    llvmPackages.openmp
    zlib
  ];

  installPhase = ''
    mkdir -p $out/bin
    ./install_kraken2.sh $out/bin
  '';

  meta = with lib; {
    description = "The second version of the Kraken taxonomic sequence classification system";
    homepage ="https://ccb.jhu.edu/software/kraken2/";
    license = licenses.mit;
  };
}
