#!/bin/sh
nix-shell ./nix/bundler.nix --run "bundler add $* --skip-install"
./nix/bundle.sh 
