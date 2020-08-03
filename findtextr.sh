#!/bin/bash
iterate_dir () {
        # If the argument given is a directory then proceed
        if [[ -d "$1" ]]; then
                # Iterate over all the  files in the directory - for regular files
                for entry in "$1/".* "$1"/*; do
                        grepRes=""
                        # If Regular file then proceed
                        if [[ -f "$entry" ]]; then
                                # Using grep with -l option which outputs the filename if pattern found
				# grep with --quiet option can also be used here 
                                grepRes=`grep -l "$PATTERN" "$entry"`
                                if [[ ! -z "$grepRes" ]]; then
                                        if [[ -z "$PROGRAM" ]]; then
                                                echo "$(realpath "$entry")"
                                        else
                                                echo `$(which "$PROGRAM") "$(realpath "$entry")"`
                                        fi
                                fi
                        fi
                done
                # Iterate over all the  files in the directory - for directories
                for entry in "$1/".* "$1"/*; do
                        if [[ -d "$entry" ]]; then
                                # Skip the . and .. directories
                                if [[ $(basename "$entry") == . || $(basename "$entry") == .. ]]; then
                                        continue
                                fi
                                # Making recursive call
                                iterate_dir "$entry"
                        fi
                done
        else
                ERR=$((ERR+1))
                echo "ERROR: $DIRECTORY is not a directory"
        fi
}

# Check atleast two arguments are given
if [[ "$#" -lt 2 ]]; then
        echo "Invalid number of arguments were given"
        echo "Usage: findtext [--program=PROGRAM] PATTERN DIRECTORY..."
        exit 1;
fi


# Check for option(s)
PROGRAM=""
if [[ "$1" == -* ]]; then
        case "$1" in
                --program=*) PROGRAM="${1#--program=}" ;;
                *) echo "Invalid option: ${1#=}" ;;
        esac
        # Remove the processed option
        shift
fi


# Get the PATTERN argument and shift
PATTERN="$1"
shift


# Check at least one DIRECTORY is given
if [[ -z $@ ]]; then
        echo "We expect at least one DIRECTORY"
        echo "Usage: findtext [--program=PROGRAM] PATTERN DIRECTORY..."
        exit 1;
fi


# Couter to keep track of Errors
ERR=0


# Iterate all the dirs 
# Using "${@%/}" instead of "$@" to remove trailing slash if present in the argument
for DIRECTORY in "${@%/}"; do
        iterate_dir "$DIRECTORY"

done

if [[ $ERR -ne 0 ]]; then
        echo "Sorry!!! We encountered $ERR issue(s)"
        exit 1
else
	exit 0
fi