{
  lib,
  stdenv,
  kraken2,
  fetchFromGitHub,
  unzip,
  repeatmasker,
  bionix,
  bcftools,
  zulu
}:

stdenv.mkDerivation rec {
  pname = "VIRUSBreakend";
  version = "2.13.2";

  src = fetchFromGitHub {
    url = "https://github.com/PapenfussLab/gridss/archive/refs/tags/v2.13.2.tar.gz";
    hash = "sha256-15s31hhcg9q10h31gbhhpnfbi1s4w204cbpb8nvr1iiqfl0sy7h1";
  };

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  buildInputs = [ 
    kraken2
    repeatmasker
    bionix.samtools
    bionix.bwa
    bionix.gridss
    bcftools
    zulu
    ];

  unpackPhase = ''
    tar xf $src
    cd gridss-${version}/scripts
    mkdir -p vbreak-${version}
    mv virusbreakend virusbreakend-build vbreak-${versiosn}
    cd vbreak-${version}
  '';

  installPhase = ''
    mkdir -p $out/bin
    # Create wrappers for main executables
    for script in $out/bin/virusbreakend $out/bin/virusbreakend-build; do
      if [ -f "$script" ]; then
        makeWrapper $script $out/bin/$(basename $script) \
          --prefix PATH : ${lib.makeBinPath [ kraken2 repeatmasker bionix.samtools bionix.bwa bionix.gridss bcftools zulu ]} \
      fi
    done
  '';

    meta = with lib; {
    description = "VIRUSBreakend Project";
    homepage = "https://ccb.jhu.edu/software/kraken2/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [];
  };
}