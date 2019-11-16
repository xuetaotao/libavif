: # If you want libavif to build libaom for you, you must clone the aom repo in this directory first, then enable CMake's AVIF_CODEC_AOM and AVIF_LOCAL_AOM options.
: # The git SHA below is known to work, and will occasionally be updated. Feel free to use a more recent commit.

: # The odd choice of comment style in this file is to try to share this script between *nix and win32.

git clone -n https://aomedia.googlesource.com/aom && cd aom && git checkout 60d06c8721605ecd40c3b21bdd3685115b82ebf2 && cd ..
