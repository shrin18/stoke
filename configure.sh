#!/bin/bash

function show_help {
  echo "$0 [--debug-default-target] [--debug-ddec] [--debug-ceg] [--no-cvc4]"
  echo ""
}

function error {
  echo "Configure failed!  Fix errors and run again."
  echo ""
  rm -f .stoke_config
  show_help
  exit
}

## START

## All options are off by default
MISC_OPTIONS=""

## Detect platform
$(grep avx2 /proc/cpuinfo >/dev/null)
AVX2=$?
$(grep avx /proc/cpuinfo >/dev/null)
AVX=$?
$(grep avx /proc/cpuinfo >/dev/null)
MMX=$?

if [ $AVX2 -eq 0 ]; then
  PLATFORM="haswell"
elif [ $AVX -eq 0 ]; then
  PLATFORM="sandybridge"
elif [ $MMX -eq 0]; then
  PLATFORM="nehalem"
else
  echo "ERROR: STOKE is currently only supported on sandybridge or haswell machines.  You appear to an older CPU"
exit 1
fi

## Now do some parsing, look for options

BUILD_TYPE="release"

while :; do
  case $1 in
    -h|--help)
      show_help
      exit
      ;;
    --debug-ddec)
      MISC_OPTIONS="$MISC_OPTIONS -DSTOKE_DEBUG_DDEC"
      shift
      ;;
    --debug-ceg)
      MISC_OPTIONS="$MISC_OPTIONS -DSTOKE_DEBUG_CEG"
      shift
      ;;
    -d|--debug-default-target)
      BUILD_TYPE="debug"
      shift
      ;;
    --no-cvc4)
