{
  description = "Ansible Collection: sigcorp.core";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          # buildInputs = with pkgs; [
          #   poetry
          # ];
          packages = with pkgs; [
            nix-search-cli
            pre-commit
            curl
            git
            jq
            just
            unzip
            watchexec
            wget
            which
            nushell

            # Run github actions locally
            act

            # Make sure nix works within the shell
            nixStatic

            # Python
            poetry
            python3

            # Other packages needed for compiling python libs
            readline
            libffi
            openssl
            glibcLocalesUtf8
          ];

          shellHook = ''
            export LANG=en_US.utf8
            export LC_ALL=en_US.utf8

            poetry env use $(which python3)
            poetry install
            . $(poetry env info -p)/bin/activate

            SHELL_HOOK_D=".shellHook.d"
            [ -d "$SHELL_HOOK_D" ] && for F in $SHELL_HOOK_D/*.sh; do echo "Sourcing $F ..."; . "$F"; done
          '';
        };
      });
}
