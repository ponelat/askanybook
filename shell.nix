with import <nixpkgs> {};
let
  rubyEnv = pkgs.bundlerEnv {
    inherit ruby;
    name = "askmybook";
    gemdir = ./.;
    gemset = ./nix/gemset.nix;

    gemConfig = pkgs.defaultGemConfig // {
      sqlite3 = attrs: {
          nativeBuildInputs = [ pkg-config ];
          buildInputs = [ sqlite ];
          buildFlags = [
            "--enable-system-libraries"
          ];
        };
    };

  };

in

pkgs.mkShell {

  buildInputs = [
    rubyEnv
    rubyEnv.wrappedRuby
    pkgs.entr
    pkgs.nodejs
    pkgs.yarn
  ];

}

