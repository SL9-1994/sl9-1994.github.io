with (import <nixpkgs> {}); let
  env = bundlerEnv {
    name = "sl9-1994.github.io";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in
  stdenv.mkDerivation {
    name = "sl9-1994.github.io";
    buildInputs = [env ruby];

    shellHook = ''
      exec ${env}/bin/jekyll serve --watch
    '';
  }