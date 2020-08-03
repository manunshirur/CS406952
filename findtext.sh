#!/bin/bash

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
# Using "${@%/}" instead of "$@" to remove trailing slash if present in the DIRECTORY argument
for DIRECTORY in "${@%/}"; do
        # Check if DIRECTORY is actually a directory else increase ERR value
        if [[ -d "$DIRECTORY" ]]; then
		# Iterate through all the files including hidden files
                for entry in "$DIRECTORY/".* "$DIRECTORY"/*; do
                        grepRes=""
			# Check for regular file
                        if [[ -f "$entry" ]]; then
				# Using grep with -l option which outputs the filename if pattern found
				# grep with --quiet option can also be used here 
                                grepRes=`grep -l "$PATTERN" "$entry"`
				# If PATTERN found
                                if [[ ! -z "$grepRes" ]]; then
					# Check PROGRAM is given
                                        if [[ -z "$PROGRAM" ]]; then
                                                echo "$(realpath "$entry")"
                                        else
                                                echo `$(which "$PROGRAM") "$(realpath "$entry")"`
                                        fi
                                fi
                        fi
                done
        else
		# Increase the error ERR value
                ERR=$((ERR+1))
                echo "ERROR: $DIRECTORY is not a directory"
        fi
done

if [[ $ERR -ne 0 ]]; then
        echo "Sorry!!! We encountered $ERR issue(s)"
        exit 1
else
        exit 0
fi
