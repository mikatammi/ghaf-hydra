#!/usr/bin/env bash
set -xeuo pipefail
nix flake lock --update-input ghaf
curl https://raw.githubusercontent.com/tiiuae/ghaf/main/flake.lock -o flake.lock
nix flake show

if [[ $(git status --porcelain --untracked-files=no) ]]; then
	git add flake.lock
	git commit -s -m "Update flake.lock"
	git push
fi
