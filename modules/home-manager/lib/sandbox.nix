# Programs that handle untrusted files or data, each in a bubblewrap sandbox
# via nixpak. They only see the directories bound here, Wayland only through a
# proxy that forwards plain client protocols, and D-Bus only through
# xdg-dbus-proxy.
{
  lib,
  pkgs,
  inputs,
}:
let
  mkNixPak = inputs.nixpak.lib.nixpak { inherit lib pkgs; };
  inherit (inputs.nixpak) nixpakModules;
  inherit (nixpakModules) network;

  sandbox =
    package: module:
    (mkNixPak {
      config = {
        imports = [ module ];
        app.package = package;
      };
    }).config.env;

  # Graphical programs. The Wayland proxy keeps them away from privileged
  # protocols such as screencopy, data-control and virtual keyboards.
  gui =
    { lib, ... }:
    {
      imports = [ nixpakModules.gui-base ];
      waylandProxy.enable = true;
      bubblewrap.sockets.wayland = lib.mkForce false;
    };

  xdgConfig = sloth: dir: sloth.concat' sloth.xdgConfigHome "/${dir}";
  state = sloth: dir: sloth.mkdir (sloth.concat' sloth.xdgStateHome "/${dir}");
  data = sloth: dir: sloth.mkdir (sloth.concat' sloth.xdgDataHome "/${dir}");
in
{
  zathura = sandbox pkgs.zathura (
    { sloth, ... }:
    {
      imports = [ gui ];
      flatpak.appId = "org.pwmt.zathura";
      bubblewrap = {
        bind.ro = [
          (xdgConfig sloth "zathura")
          sloth.xdgDocumentsDir
          sloth.xdgDownloadDir
        ];
        # History and bookmarks
        bind.rw = [ (data sloth "zathura") ];
      };
    }
  );

  imv = sandbox pkgs.imv (
    { sloth, ... }:
    {
      imports = [ gui ];
      flatpak.appId = "io.sr.imv";
      # bin/imv only dispatches to the Wayland binary
      app.binPath = "bin/imv-wayland";
      bubblewrap.bind.ro = [
        (xdgConfig sloth "imv")
        sloth.xdgPicturesDir
        sloth.xdgDownloadDir
        sloth.xdgDocumentsDir
      ];
    }
  );

  mpv = sandbox pkgs.mpv (
    { sloth, ... }:
    {
      imports = [ gui ];
      flatpak.appId = "io.mpv.Mpv";
      bubblewrap = {
        bind.ro = [
          (xdgConfig sloth "mpv")
          sloth.xdgVideosDir
          sloth.xdgMusicDir
          sloth.xdgDownloadDir
        ];
        # Resume positions
        bind.rw = [ (state sloth "mpv") ];
      };
    }
  );

  signal-desktop = sandbox pkgs.signal-desktop (
    { sloth, ... }:
    {
      imports = [
        gui
        network
      ];
      flatpak.appId = "org.signal.Signal";
      dbus.policies = {
        "org.freedesktop.Notifications" = "talk";
        "org.freedesktop.secrets" = "talk";
        "org.kde.StatusNotifierWatcher" = "talk";
      };
      bubblewrap.bind.rw = [
        (sloth.mkdir (xdgConfig sloth "Signal"))
        sloth.xdgDownloadDir
      ];
    }
  );

  # POLICIES as programs.librewolf.policies, applied like home-manager does
  librewolf =
    policies:
    sandbox
      (pkgs.librewolf.override (old: {
        extraPolicies = (old.extraPolicies or { }) // policies;
      }))
      (
        { sloth, ... }:
        {
          imports = [
            gui
            network
          ];
          flatpak.appId = "io.gitlab.librewolf-community";
          dbus.policies = {
            "org.freedesktop.Notifications" = "talk";
            "org.freedesktop.ScreenSaver" = "talk";
            "org.mpris.MediaPlayer2.firefox.*" = "own";
            "org.mozilla.librewolf.*" = "own";
          };
          bubblewrap.bind.rw = [
            (sloth.mkdir (sloth.concat' sloth.homeDir "/.librewolf"))
            (sloth.mkdir (sloth.concat' sloth.xdgCacheHome "/librewolf"))
            sloth.xdgDownloadDir
          ];
        }
      );

  mbsync =
    {
      maildir,
      secret,
    }:
    sandbox pkgs.isync (
      { sloth, ... }:
      {
        imports = [ network ];
        dbus.enable = false;
        bubblewrap.bind = {
          ro = [
            (xdgConfig sloth "isyncrc")
            secret
          ];
          rw = [ (sloth.concat' sloth.homeDir "/${maildir}") ];
        };
      }
    );

  msmtp =
    { secret }:
    sandbox pkgs.msmtp (
      { sloth, ... }:
      {
        imports = [ network ];
        dbus.enable = false;
        bubblewrap.bind.ro = [
          (xdgConfig sloth "msmtp")
          secret
        ];
      }
    );

  mu =
    { maildir }:
    sandbox pkgs.mu (
      { sloth, ... }:
      {
        dbus.enable = false;
        bubblewrap = {
          network = false;
          bind.rw = [
            (sloth.concat' sloth.homeDir "/${maildir}")
            (sloth.mkdir (sloth.concat' sloth.xdgCacheHome "/mu"))
          ];
        };
      }
    );
}
