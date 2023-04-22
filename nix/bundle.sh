# ./nix/bundle
#!/bin/sh
nix-shell ./nix/bundler.nix \
    --run "bundler lock $* && bundix --gemset=./nix/gemset.nix"
