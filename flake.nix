{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = forEachSystem (system: {
        devenv-up = self.devShells.${system}.default.config.procfileScript;
      });

      devShells = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            day1 = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  languages.rust = {
                    enable = true;
                  };

                  scripts.run-test.exec = ''
                    cargo test
                  '';

                  scripts.run.exec = ''
                    cargo run
                  '';
                }
              ];
            };

            day2 = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  languages.elixir.enable = true;

                  scripts.run-test.exec = ''
                    elixir day2_test.exs
                  '';

                  scripts.run.exec = ''
                    elixir main.exs
                  '';
                }
              ];
            };

            day3 = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  languages.gleam.enable = true;
                  languages.erlang.enable = true;

                  scripts.run-test.exec = ''
                    gleam test
                  '';

                  scripts.run.exec = ''
                    gleam run
                  '';
                }
              ];
            };
          });
    };
}
