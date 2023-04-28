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

    #   tiktoken_ruby = attrs: {
    #     # preBuild = ''
    #     preInstall = ''
    #         echo Howdy
    #         # mkdir home
    #         # export RUSTUP_HOME=$PWD/home
    #         # rustup override set 1.50.0
    #         # rustup default stable
    #         # rustup install stable
    #         # rustup default stable
    #     '';
    #     nativeBuildInputs = with pkgs; [
    #       rustc
    #       cargo
    #       # rustup
    #       # clang
    #       # llvmPackages.bintools
    #     ];
    #     dependencies = [ "rb_sys" ];
    #   };

    };
  };

in

pkgs.mkShell {

  buildInputs = [
    rubyEnv
    rubyEnv.wrappedRuby
    pkgs.entr

    pkgs.nodejs-18_x
  ];

}

