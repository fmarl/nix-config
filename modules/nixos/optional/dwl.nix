{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.dwl;
in
{
  options.modules.dwl = {
    enable = mkEnableOption "Install and configure dwl";

    patches = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = "List of patch files to apply to dwl";
    };

    config = mkOption {
      type = types.path;
      description = "Configuration for dwl";
    };
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    services.xserver = {
      enable = true;

      displayManager.lightdm.enable = true;

      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
    };

    environment.systemPackages = [
      (pkgs.stdenv.mkDerivation {
        pname = "dwl";
        version = "git";

        src = pkgs.fetchgit {
          url = "https://codeberg.org/dwl/dwl.git";
          rev = "2783d91611a027cfecc43a39689b6e589578a88b";
          sha256 = "sha256-NBzrOM6L7my8RgK84qnQ5TALuMPBbHW8GVnm6z6CV/o=";
        };

        patches = cfg.patches;

        nativeBuildInputs = with pkgs; [
          pkg-config
          wayland-protocols
          wayland-scanner
        ];

        buildInputs = with pkgs; [
          libinput
          xorg.libxcb
          libxkbcommon
          pixman
          wayland
          wayland-protocols
          wlroots
          xorg.libX11
          xwayland
          xorg.xcbutilwm
        ];

        postPatch = ''
          sed -i 's/-O0/-O2/' config.mk
          cp ${cfg.config} config.def.h
        '';

        dontConfigure = true;
        configHasChanged = builtins.hashString "sha256" (toString cfg.config);

        installPhase = ''
          runHook preInstall
          make install DESTDIR=$out PREFIX=
          runHook postInstall
        '';
      })
    ];
  };
}
