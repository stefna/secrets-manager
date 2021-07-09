#!/usr/bin/env bash
DIR="$(cd "$(dirname "$0")" && pwd)"

declare -A repositories=(
	["packages/core"]="secrets-manager-core"
	['packages/json-provider']="secrets-manager-json-provider"
	['packages/psr-6-provider']="secrets-manager-psr6-provider"
	['packages/aws-parameter-store-provider']="secrets-manager-aws-ssm-provider"
	['packages/aws-secrets-manager-provider']="secrets-manager-aws-secrets-manager-provider"
)

mainBranch="main"

currentBranch=$(git rev-parse --abbrev-ref HEAD)

for repoPath in "${!repositories[@]}" ; do
	echo "Path: $repoPath"
	echo "Repo: ${repositories[$repoPath]}"

	repoName=${repositories[$repoPath]}

	git checkout "$mainBranch"

	$DIR/splitsh-lite --prefix="$repoPath" --target=heads/"$repoName"
	git remote add "$repoName" "git@github.com:stefna/$repoName.git"
	git checkout heads/"$repoName"
	git push "$repoName" HEAD:"$mainBranch"
done
git checkout "$currentBranch"
