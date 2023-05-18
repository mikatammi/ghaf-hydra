#!/usr/bin/env bash
curl https://raw.githubusercontent.com/tiiuae/ghaf/main/flake.lock -o flake.lock
nix flake show
