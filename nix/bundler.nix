with import <nixpkgs> {};
let
  ruby = pkgs.ruby_3_1;
in
pkgs.mkShell {
  buildInputs = with pkgs;[
    ruby
    bundler
    bundix
  ];

  # Prevents Gemfile.lock from getting platform-specific gems.
  # You'll bump into this if you see nokogiri SHA conflicts with nix.
  # See: https://nixos.org/manual/nixpkgs/stable/#id-1.5.8.32.3.4
  BUNDLE_FORCE_RUBY_PLATFORM = 1;
}
