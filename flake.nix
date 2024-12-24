{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";

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
      hbuild = pkgs.writeShellScriptBin "hbuild" ''
        #!/usr/bin/env bash
        home-manager switch --flake . $@
      '';

      nbuild = pkgs.writeShellScriptBin "nbuild" ''
        #!/usr/bin/env bash
        sudo nixos-rebuild switch --flake . $@
      '';

      system = "x86_64-linux";

      pkgs =
        import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

      commonNixOSModules = host: [
        (import ./modules/nixos {
          inherit inputs host;
        })
        ./hosts/${host}/nixos/configuration.nix
        inputs.sops-nix.nixosModules.sops
      ];

      commonHomeManagerModules = user: host: [
        (import ./modules/home-manager {
          inherit pkgs inputs host user;
        })
        ./hosts/${host}/home-manager/home.nix
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
      checks = {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
          };
        };
      };

      nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem systems.nixos;

      homeConfigurations = nixpkgs.lib.mapAttrs mkHomeManager systems.homes;

      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          nixpkgs-fmt
          hbuild
          nbuild
          (inputs.nix-code.vscode.${system} {
            extensions = with inputs.nix-code.extensions.${system}; [
              bbenoist.nix
              jnoortheen.nix-ide
              mkhl.direnv
            ];
          })
        ];
      };
    };
}
