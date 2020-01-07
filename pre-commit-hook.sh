#!/usr/bin/env bash
# Exit on error
# exit when any command fails
set -e
set -o pipefail

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' ERR

# - Actual script
STAGED_FILES=`git diff --name-only --cached --diff-filter=d`
echo "Staged files ${STAGED_FILES}"

# Build edit string, by replacing newlines with semicolons.
# --diff-filter=d only filters files that are not deleted, which means we won't have trouble adding them afterwards
INCLUDE_STRING=`git diff --name-only --cached --diff-filter=d | sed ':a;N;$!ba;s/\n/;/g'`
echo "Include string: $INCLUDE_STRING"

# Edit your project files here
echo "Formatting files..."
sh ./.git/hooks/resharper/cleanupcode.sh --profile="Built-in: Reformat Code" ./OAI.sln --include="$INCLUDE_STRING"

# Restage files
echo "Restaging files: $STAGED_FILES"
echo $STAGED_FILES | xargs -t -l git add

echo "pre-commit hook finished"