#!/bin/env bash
bashrc='/etc/bash.bashrc'
profile='/etc/profile'

pushd . > '/dev/null';
SCRIPT_PATH="${BASH_SOURCE[0]:-$0}";

while [ -h "$SCRIPT_PATH" ];
do
    cd "$( dirname -- "$SCRIPT_PATH"; )";
    SCRIPT_PATH="$( readlink -f -- "$SCRIPT_PATH"; )";
done
#set -x
cd "$( dirname -- "$SCRIPT_PATH"; )" > '/dev/null';
SCRIPT_PATH="$PWD";
popd  > '/dev/null';
inputfile="$SCRIPT_PATH/GPE.settings"
customAlias=$( sed '40!d' "$inputfile" )
boundaryBefore='#GPEALIAS'
boundaryAfter='#GPEALIASEND'
chmod u+r+x "$SCRIPT_PATH/GPESetter.sh"
chmod u+r+x "$SCRIPT_PATH/GitPromptExtension.sh"
output=$(echo "$boundaryBefore"
\
echo "alias $customAlias='. "$SCRIPT_PATH"/GPESetter.sh'"
\
echo "$boundaryAfter")

grep -q "$boundaryBefore" "$bashrc"; isGpeAliasPresent=$((!$?))
grep -q "$boundaryAfter" "$bashrc"; isGpeEndPresent=$((!$?))

if [ "$isGpeAliasPresent" -eq 1 ] && [ "$isGpeEndPresent" -eq 1 ]; then
    output=$(sed -e '/^’”$boundaryBefore”’/r exceptions' -e '/^’”$boundaryBefore”’/,/^’”$boundaryAfter”’/c'"$output"'' "$bashrc")
    echo "$output" | sudo tee "$bashrc"
else
  echo "$output" | sudo tee -a "$bashrc"
fi

grep -q "$boundaryBefore" "$profile"; isGpeAliasPresent=$((!$?))
grep -q "$boundaryAfter" "$profile"; isGpeEndPresent=$((!$?))

if [ "$isGpeAliasPresent" -eq 1 ] && [ "$isGpeEndPresent" -eq 1 ]; then
    output=$(sed -e '/^’”$boundaryBefore”’/r exceptions' -e '/^’”$boundaryBefore”’/,/^’”$boundaryAfter”’/c'"$output"'' "$profile")
    echo "$output" | sudo tee "$profile"
else
  echo "$output" | sudo tee -a "$profile"
fi

echo "alias $customAlias setup"
echo -e "\033[0;31mplease restart your console for this to take effect\033[0m"
echo "type $customAlias in a terminal session to start it"
echo "when you are in a directory with a GIT"
echo "it will automatically work"
