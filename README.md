# CS406-952 Linux System Administration
This script can search through a directory to find files that contain a particular text pattern and print out the paths
of such files. Optionally, it can apply a script/program to each matching file.

The syntax for findtext is:
findtext [--program=PROGRAM] PATTERN DIRECTORY...

Similarly, The syntax for findtextr is:
findtextr [--program=PROGRAM] PATTERN DIRECTORY...

PATTERN is to be a REGEXP consistent with grep’s basic regular expression syntax. If at least one match of the pattern is found in a file, the file is
considered matched.

If PROGRAM is not supplied, script simply print out the absolute path of each matched file.

If the --program option is given, instead of printing out each matched file’s path, the script will call the specified program for each matched file, passing each matching file’s absolute path as the only command-line argument to the program.
