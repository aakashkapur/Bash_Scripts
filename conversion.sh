#!/bin/bash

set -euo pipefail

usage() {
    echo "Usage: $0 --input <input_file> --output <output_file> [--from <from_format>] [--to <to_format>]"
}

while [ $# -gt 0 ]; do
    case "$1" in
        --input|-i)
            INPUT_FILE="$2"
            shift 2
            ;;
        --from|-f)
            FROM_FORMAT="$2"
            shift 2
            ;;
        --to|-t)
            TO_FORMAT="$2"
            shift 2
            ;;
        --output|-o)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            break
            ;;
    esac
done


[ -z ${INPUT_FILE:-} ] && { echo "Error: --input is required"; usage; exit 1; }
[ -z ${OUTPUT_FILE:-} ] && { echo "Error: --output is required"; usage; exit 1; }
[ -z ${FROM_FORMAT:-} ] && { echo "Error: --from is required"; usage; exit 1; }
[ -z ${TO_FORMAT:-} ] && { echo "Error: --to is required"; usage; exit 1; }
echo "Converting '$INPUT_FILE' from '$FROM_FORMAT' to '$TO_FORMAT' and saving to '$OUTPUT_FILE'"


convert() {
  local from="$1" to="$2" input="$3"
  case "$from:$to" in
    json:yaml) yq -P -o yaml '.' < "$input" ;;
    yaml:json) yq -o json '.' < "$input" ;;
  esac
}
convert "$FROM_FORMAT" "$TO_FORMAT" "$INPUT_FILE" > "$OUTPUT_FILE"