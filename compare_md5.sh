#!/bin/bash
#This script compares MD5 checksums of files in two directories.
show_help() {
    echo "Usage: $0 --dir1 <directory1> --dir2 <directory2>"
    echo
    echo "Compares MD5 checksums of files in two directories."
    echo
    echo "Options:"
    echo "  --dir1 <directory1>   Path to the first directory"
    echo "  --dir2 <directory2>   Path to the second directory"
    echo "  --help                Show this help message"
    exit 0
}
while [ $# -gt 0 ]; do
    case "$1" in
        --dir1|-d1)
            DIR1="$2"
            shift 2
            ;;
        --dir2|-d2)
            DIR2="$2"
            shift 2
            ;;
        --help)
            show_help
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

if [ -z "$DIR1" ] || [ -z "$DIR2" ]; then
    echo "Error: Both --dir1 and --dir2 options are required."
    show_help
    exit 1
fi
if [ ! -d "$DIR1" ]; then
    echo "Error: Directory '$DIR1' does not exist."
    exit 1
fi
if [ ! -d "$DIR2" ]; then
    echo "Error: Directory '$DIR2' does not exist."
    exit 1
fi

tmp1=$(mktemp)
tmp2=$(mktemp)

# Generate MD5 sums with relative paths
(cd "$DIR1" && find . -type f -exec md5sum {} +) | sort > "$tmp1"
(cd "$DIR2" && find . -type f -exec md5sum {} +) | sort > "$tmp2"

diff_output=$(diff -u "$tmp1" "$tmp2")
if [ -z "$diff_output" ]; then
    echo "The directories have identical files."
else
    echo "Differences found between the directories:"
    echo "$diff_output"
fi

