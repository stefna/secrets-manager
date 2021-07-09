#!/usr/bin/env bash
DIR="$(cd "$(dirname "$0")" && pwd)"

declare -A repositories=(
	["packages/core"]="secrets-manager-core"
)

declare -A branches=(
	["packages/core"]="secrets-manager-core"
)

mainBranch="main"

currentBranch=$(git rev-parse --abbrev-ref HEAD)

for repoPath in "${!repositories[@]}" ; do
	echo "Path: $repoPath"
	echo "Repo: ${repositories[$repoPath]}"
	echo "Branch: ${branches[$repoPath]}"

	repoName=${repositories[$repoPath]}
	repoBranch=${branches[$repoPath]}

	git checkout "$mainBranch"

	$DIR/splitsh-lite --prefix="$repoPath" --target=heads/"$repoBranch"
	git remote add "$repoBranch" "git@github.com:stefna/$repoName.git"
	git checkout heads/"$repoBranch"
	git push "$repoBranch" HEAD:main
done
git checkout "$currentBranch"
