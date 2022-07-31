#!/bin/sh

while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--sudo)
      SUDO="sudo"
      shift
      ;;
    -p|--password)
      PASSWORD="$2"
      shift
      shift
      ;;
    -i|--input)
      SOURCE="$2"
      shift
      shift
      ;;
    -t|--target)
      TARGET="$2"
      shift
      shift
      ;;
    *)
      echo "Unknown option $1" >&2
      exit 1
  esac
done

[[ -z "$SOURCE" ]] && echo "-i or --input must be provided" >&2 && exit 1
[[ -z "$TARGET" ]] && echo "-t or --target must be provided" >&2 && exit 1

$SUDO 7z a -t7z -m0=lzma2 -mx=9 -mfb=64 -md=32m -ms=on -mhe=on -p"${PASSWORD}" "$TARGET" "$SOURCE"
