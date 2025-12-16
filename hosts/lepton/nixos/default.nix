{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./services.nix
    ./networking.nix
    ./security.nix
    ./users.nix
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

  programs = {
    zsh.enable = true;
  };

  modules = {
    niri.enable = true;
  };

  containers.emacs = lib.containerUtils.wayland.gen {
    hmConfig = {
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
  };

  environment = {
    shells = with pkgs; [ zsh ];
    pathsToLink = [ "/share/zsh" ];
    defaultPackages = lib.mkForce [ ];
    systemPackages = with pkgs; [
      vim
      git
      home-manager
      htop
    ];
  };

  fonts.packages = with pkgs; [
    source-code-pro
    font-awesome
  ];

  services.blueman.enable = true;

  # virtualisation = {
  #   containers.enable = true;
  #   podman = {
  #     enable = true;
  #     dockerCompat = true;
  #     defaultNetwork.settings.dns_enabled = true;
  #   };

  #   libvirtd = {
  #     enable = true;
  #     qemu = {
  #       package = pkgs.qemu_kvm;
  #       runAsRoot = true;
  #       swtpm.enable = true;
  #     };
  #   };
  # };
}
