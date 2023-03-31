#!/bin/env bash
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    exit 0
fi

declare -A colours=(
    ["Black"]='\033[0;30m'
    ["DarkGray"]='\033[1;30m'
    ["Red"]='\033[0;31m'
    ["LightRed"]='\033[1;31m'
    ["Green"]='\033[0;32m'
    ["LightGreen"]='\033[1;32m'
    ["Orange"]='\033[0;33m'
    ["Yellow"]='\033[1;33m'
    ["Blue"]='\033[0;34m'
    ["LightBlue"]='\033[1;34m'
    ["Purple"]='\033[0;35m'
    ["LightPurple"]='\033[1;35m'
    ["Cyan"]='\033[0;36m'
    ["LightCyan"]='\033[1;36m'
    ["LighGray"]='\033[0;37m'
    ["White"]='\033[1;37m'
    ["NoColour"]='\033[0m')

headName=$(git symbolic-ref --short HEAD)
fullBranchStatus=$(git status -sb)
branchStatus=$(echo "$fullBranchStatus" | head -1)
branchStatusSameIndicator="≡"
branchStatusBehindIndicator="↓"
branchStatusAheadIndicator="↑"

pushd . > '/dev/null';
SCRIPT_PATH="${BASH_SOURCE[0]:-$0}";

while [ -h "$SCRIPT_PATH" ];
do
    cd "$( dirname -- "$SCRIPT_PATH"; )";
    SCRIPT_PATH="$( readlink -f -- "$SCRIPT_PATH"; )";
done

cd "$( dirname -- "$SCRIPT_PATH"; )" > '/dev/null';
SCRIPT_PATH="$PWD";
popd  > '/dev/null';

inputfile="$SCRIPT_PATH/GPE.settings"

bracketColour=$(sed '26!d' "$inputfile")
branchNameStatusIndicatorColour=$(sed '29!d' "$inputfile")
StagedStatsColour=$(sed '32!d' "$inputfile")
UnstagedStatsColour=$(sed '35!d' "$inputfile")

#by default, it is same until otherwise stated
BranchStatusInidicator=$branchStatusSameIndicator

case $branchStatus in
    *"behind"*)
        BranchStatusInidicator=$branchStatusBehindIndicator
        ;;
    *"ahead"*)
        BranchStatusInidicator=$branchStatusAheadIndicator
        ;;
esac

stagedModifiedCounter=0
stagedDeletedCounter=0
stagedAddedCounter=0
unstagedModifiedCounter=0
unstagedDeletedCounter=0
unstagedAddedCounter=0

while read line
do
#echo "$line"
#echo "$(echo "${line// /_}" | cut -c1 | rev)"
staged="${line:0:1}"
#echo "$staged"
unstaged="${line:1:1}"
#echo "$unstaged"
    case "$staged" in
        "M")
        stagedModifiedCounter=$((stagedModifiedCounter+1))
        ;;
        "D")
        stagedDeletedCounter=$((stagedDeletedCounter+1))
        ;;
        "A")
        stagedAddedCounter=$((stagedAddedCounter+1))
        ;;
    esac
    case $unstaged in
        "M")
        unstagedModifiedCounter=$((unstagedModifiedCounter+1))
        ;;
        "D")
        unstagedDeletedCounter=$((unstagedDeletedCounter+1))
        ;;
        "?")
        unstagedAddedCounter=$((unstagedAddedCounter+1))
        ;;
    esac
done <<< "${fullBranchStatus// /_}"

unstagedCombined=$((unstagedAddedCounter+unstagedModifiedCounter+unstagedDeletedCounter))
[[ $unstagedCombined -gt 0 ]] && unstagedChangesSymbol="!" || unstagedChangesSymbol=""

# staged is left of the bar=|, modified but not staged is right of the |=bar
finalOutput="${colours["$bracketColour"]}[${colours["$branchNameStatusIndicatorColour"]}${headName} ${BranchStatusInidicator}
\
${colours["$StagedStatsColour"]}+${stagedAddedCounter} ~${stagedModifiedCounter} -${stagedDeletedCounter}
\
${colours["$bracketColour"]}|
\
${colours["$UnstagedStatsColour"]}+${unstagedAddedCounter} ~${unstagedModifiedCounter} -${unstagedDeletedCounter} ${unstagedChangesSymbol}${colours["$bracketColour"]}]${colours["NoColour"]}"

echo -e $finalOutput
