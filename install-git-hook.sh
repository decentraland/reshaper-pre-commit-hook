#!/usr/bin/env bash
# Exit on error
# exit when any command fails
set -e
set -o pipefail

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' ERR

outFile="./resharper-cli.zip"
gitResharperFolder="./.git/hooks/resharper"
preCommitFile="./.git/hooks/pre-commit"
cliUrl="https://download.jetbrains.com/resharper/dotUltimate.2020.3.3/JetBrains.ReSharper.CommandLineTools.2020.3.3.zip"
preCommitHookUrl="https://raw.githubusercontent.com/GeeWee/reshaper-pre-commit-hook/master/pre-commit-hook.sh"


echo "Fetching Resharper CLI tools"
curl -L ${cliUrl} > ${outFile}

echo "Cleaning up old versions"
rm -rf ${gitResharperFolder} # Delete any old versions
mkdir -p ${gitResharperFolder}
echo "Extracting into ${gitResharperFolder}"
unzip "./${outFile}" -d ${gitResharperFolder}

echo "Adding pre-commit hook"
curl -s ${preCommitHookUrl} > ${preCommitFile}

echo "Marking as executable"
chmod u+x ${preCommitFile}


echo "Cleaning up..."
rm -f ${outFile}