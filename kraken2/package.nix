{
  lib,
  stdenv,
  fetchFromGitHub,
  rsync,
  perl,
  wget,
  llvmPackages,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kraken2";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "DerrickWood";
    repo = "kraken2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9ZW29SXWzy/fZreOmNnjywwlaSReZXnqq+uzGsuWP2g=";
  };

  buildInputs = [
    rsync
    perl
    wget
    llvmPackages.openmp
    zlib
  ];

  installFlags = [ "KRAKEN2_DIR=$(out)/bin" ];

  meta = {
    description = "The second version of the Kraken taxonomic sequence classification system.";
    homepage = "https://ccb.jhu.edu/software/kraken2/";
    changelog = "https://github.com/DerrickWood/kraken2/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      cardealerT
      A1egator
    ];
  };
})
