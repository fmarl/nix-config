{
  config,
  pkgs,
  lib,
  clib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./security.nix
    ./services.nix
    ./networking.nix
    ./boot.nix
  ];

  sops = {
    age = {
      keyFile = "/home/marrero/.config/sops/age/keys.txt";
      generateKey = true;
    };
  };

  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  programs.zsh.enable = true;

  modules.niri.enable = true;

  containers.emacs = clib.waylandContainer {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
      
      extraPackages =
        epkgs: with epkgs; [
          # Core
          use-package
          zenburn-theme
          moody
          smex
          ace-window
          avy
          direnv
          posframe
          magit
          projectile
          yasnippet
          yasnippet-snippets
          markdown-mode
          paredit
          rainbow-delimiters
          marginalia
          orderless
          consult
          vertico
          dirvish
          
          # LSP
          consult-eglot
          cape
          corfu

          # Nix Mode
          nix-ts-mode

          # C
          clang-format

          # Rust
          rustic

          # OCaml
          tuareg
          dune
          utop

          # Clojure
          cider

          # Gleam
          gleam-ts-mode
          
          # Mail & IRC
          circe

	  # Treesitter
	  tree-sitter-langs
	  (treesit-grammars.with-grammars (grammars: [
	    grammars.tree-sitter-rust
	    grammars.tree-sitter-ocaml
	    grammars.tree-sitter-nix
	    grammars.tree-sitter-gleam
	  ]))
        ];
    };
  };

  environment = {
    shells = with pkgs; [ zsh ];
    pathsToLink = [ "/share/zsh" ];
    defaultPackages = lib.mkForce [ ];
    systemPackages = with pkgs; [
      home-manager
    ];
  };

  fonts.packages = with pkgs; [
    source-code-pro
    font-awesome
  ];

  users = {
    mutableUsers = false;

    users = {
      marrero = {
        isNormalUser = true;
        createHome = true;
        description = "Florian Marrero Liestmann";
        hashedPasswordFile = config.sops.secrets.user-password.path;
	      extraGroups = [
          "wheel"
          "tss"
          "podman"
          "kvm"
        ];
        group = "users";
        uid = 1000;
        home = "/home/marrero";
        shell = pkgs.zsh;

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII5wD+zMGIVaENIRRxTwK0w+mqWfpeABf4JIp0zA7Vs3 marrero@ntb"
        ];
      };
    };
  };

  virtualisation = {
    containers.enable = true;
    
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
