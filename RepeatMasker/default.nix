# Unix system with perl 5.8.0 or higher installed
# Python 3 and the h5py python library.
# See https://docs.h5py.org/en/latest/build.html for installation instructions.
# Sequence Search Engine
# RepeatMasker uses a sequence search engine to perform it's search for repeats. Currently Cross_Match, RMBlast and WUBlast/ABBlast are supported. You will need to obtain one or the other of these and install them on your system.
# For Cross_Match go to http://www.phrap.org You will want to select "Phred/Phrap/Consed" as Cross_Match is part of the Phrap package.
# For RMBlast ( NCBI Blast modified for use with RepeatMasker/RepeatModeler ) please go to our download page: http://www.repeatmasker.org/rmblast. It is highly recommended to use 2.13.0 or higher.
# For HMMER please download the v3.2.1 version here: http://hmmer.org/
# For ABBlast/WUBlast go to [ NOTE: Rights to BLAST 2.0 (WU-BLAST) have been acquired by Advanced Biocomputing, LLC. http://blast.advbiocomp.com/licensing/ RepeatMasker 3.2.8 and above fully support both variants ]
# TRF - Tandem Repeat Finder, G. Benson et al.
# You can obtain a free copy at http://tandem.bu.edu/trf/trf.html. RepeatMasker was developed using TRF version 4.0.9
# Repeat Database
# RepeatMasker can be used with custom libraries, or with Dfam out of the box. Dfam is an open database of transposable element (TE) profile HMM models and consensus sequences. The current release of RepeatMasker is shipped without a TE database, however libraries in FamDB H5 format may be downloaded from Dfam at: https://www.dfam.org/releases/current/families/FamDB and installed in the Libraries/famdb directory.

{ lib, stdenv, fetchurl, perl, python3, python3Packages, hmmer, unzip, makeWrapper, trf }:

stdenv.mkDerivation rec {
  pname = "RepeatMasker";
  version = "4.1.8";

  src = fetchurl {
    url = "https://repeatmasker.org/RepeatMasker/RepeatMasker-${version}.tar.gz";
    sha256 = "sha256-5YsPNBGvVK9vTxXDRzxcMSsIeCJacZI86RLp3QF/esU=";
  };

  nativeBuildInputs = [ makeWrapper unzip ];
  buildInputs = [ perl python3 trf hmmer python3Packages.h5py ];

  unpackPhase = ''
    tar xf $src
    mv RepeatMasker RepeatMasker-${version}
    cd RepeatMasker-${version}
  '';

  configurePhase = ''
    perl ./configure -trf_prgm ${lib.getBin trf}/bin/trf \
      -libdir ./Libraries \
      -hmmer_dir ${lib.getBin hmmer}/bin \
      -default_search_engine hmmer
   '';

  buildPhase = "true";

  installPhase = ''
    mkdir -p $out
    cp -r * $out/

    # Create wrappers for main executables
    mkdir -p $out/bin
    for script in $out/RepeatMasker $out/RepeatClassifier $out/ProcessRepeats; do
      if [ -f "$script" ]; then
        makeWrapper $script $out/bin/$(basename $script) \
          --prefix PATH : ${lib.makeBinPath [ perl python3 trf hmmer ]} \
          --set REPEATMASKER_DIR $out
      fi
    done
  '';

  meta = with lib; {
    description = "A program that screens DNA sequences for interspersed repeats and low complexity DNA sequences.";
    homepage = "http://www.repeatmasker.org/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}