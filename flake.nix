{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    nix-code = {
      url = "github:fxttr/nix-code";
      inputs.extensions.follows = "nix-vscode-extensions";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "github:fxttr/secrets";
      flake = false;
    };

    media = {
      url = "github:foxt/macOS-Wallpapers";
      flake = false;
    };
  };
  
  outputs = { self, nixpkgs, flake-utils, home-manager, ... }@inputs:
    let
      hbuild = legacyPackages.writeShellScriptBin "hbuild" ''
        #!/usr/bin/env bash
        home-manager switch --flake . $@
      '';

      nbuild = legacyPackages.writeShellScriptBin "nbuild" ''
        #!/usr/bin/env bash
        sudo nixos-rebuild switch --flake . $@
      '';

      system = "x86_64-linux";

      legacyPackages =
        import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

      commonNixOSModules = host: [
        {
          sops = {
            defaultSopsFile = "${inputs.secrets}/systems/${host}.yaml";

            secrets = {
              root-password = {
                neededForUsers = true;
              };

              user-password = {
                neededForUsers = true;
              };
            };
          };

          nix = {
            gc = {
              automatic = true;
              dates = "weekly";
            };

            settings = {
              trusted-users = [ "root" "marrero" ];
              allowed-users = [ "@wheel" ];
            };

            extraOptions = "experimental-features = nix-command flakes";

            optimise.automatic = true;
          };

          networking.hostName = host;

          i18n.extraLocaleSettings = {
            LC_ADDRESS = "de_DE.UTF-8";
            LC_IDENTIFICATION = "de_DE.UTF-8";
            LC_MEASUREMENT = "de_DE.UTF-8";
            LC_MONETARY = "de_DE.UTF-8";
            LC_NAME = "de_DE.UTF-8";
            LC_NUMERIC = "de_DE.UTF-8";
            LC_PAPER = "de_DE.UTF-8";
            LC_TELEPHONE = "de_DE.UTF-8";
            LC_TIME = "de_DE.UTF-8";
          };
        }
        ./hosts/${host}/nixos/configuration.nix
        ./modules/nixos
        inputs.sops-nix.nixosModules.sops
      ];

      commonHomeManagerModules = user: host: [
        {
          nixpkgs.config.allowUnfree = true;

          sops = {
            defaultSopsFile = "${inputs.secrets}/systems/${host}.yaml";

            secrets = {
              ssh = {
                path = "/run/user/1000/secrets/ssh";
              };
            };
          };

          programs = {
            direnv = {
              enable = true;
              nix-direnv.enable = true;
            };
          };

          home = {
            username = "${user}";
            homeDirectory = "/home/${user}";
            stateVersion = "25.05";
          };

          nix = {
            package = legacyPackages.nix;
          };

          systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
        }
        ./hosts/${host}/home-manager/home.nix
        ./modules/home-manager
        inputs.sops-nix.homeManagerModules.sops
      ];

      mkSystem = name: cfg: nixpkgs.lib.nixosSystem {
        system = cfg.system or "x86_64-linux";

        pkgs = import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

        modules = (commonNixOSModules name) ++ (cfg.modules or [ ]);

        specialArgs = { inherit inputs; };
      };

      mkHomeManager = name: cfg:
        let
          system = cfg.system or "x86_64-linux";
          namePair = nixpkgs.lib.match "^(.*)@(.*)$" name;
          user = nixpkgs.lib.elemAt namePair 0;
          host = nixpkgs.lib.elemAt namePair 1;
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };

          modules = (commonHomeManagerModules user host) ++ (cfg.modules or [ ]);

          extraSpecialArgs = { inherit inputs; };
        };

      systems = {
        nixos = {
          workstation = { };

          ntb = { };
        };

        homes = {
          "marrero@workstation" = { };

          "marrero@ntb" = { };
        };
      };
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem systems.nixos;

      homeConfigurations = nixpkgs.lib.mapAttrs mkHomeManager systems.homes;

      devShells.${system}.default = legacyPackages.mkShell {
        nativeBuildInputs = with legacyPackages; [
          nixpkgs-fmt
          hbuild
          nbuild
          (inputs.nix-code.vscode.${system} {
            extensions = with inputs.nix-code.extensions.${system}; [
              bbenoist.nix
              jnoortheen.nix-ide
              mkhl.direnv
            ];

            userDir = "$HOME/.vscode/${self}";
          })
        ];
      };
    };
}
