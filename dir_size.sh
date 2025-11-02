#! /bin/bash

show_help() {
    echo "Usage: $0 -d <directory>"
    exit 0
}

while [[ $# -gt 0 ]]
do
    case $1 in
    -d|--dir)
    DIR=$2
    shift 2
    ;;
    -h|--help)
    show_help
    exit 0
    ;;
    -*)
    echo "Invalid option: $1"
    show_help
    exit 1
    ;;
    esac
done

if [ -d $DIR ]; then
    largest_file=$(find $DIR -type f -printf "%s %p\n" | sort -nr | head -n 1)
    echo "Largest file: $largest_file"

else
    echo "Directory does not exist"
    exit 1
fi
