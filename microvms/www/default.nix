{
  pkgs,
  ...
}:
{
  microvm = {
    hypervisor = "cloud-hypervisor";
    graphics.enable = true;
    mem = 4096;
    vcpu = 2;
    shares = [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
      }
    ];
  };

  networking.hostName = "www-microvm";
  system.stateVersion = pkgs.lib.trivial.release;

  services.getty.autologinUser = "user";
  users.users.user = {
    password = "";
    group = "user";
    isNormalUser = true;
    extraGroups = [
      "video"
    ];
  };
  users.groups.user = { };
  security.sudo.enable = false;

  environment.sessionVariables = {
    WAYLAND_DISPLAY = "wayland-1";
    DISPLAY = ":0";
    QT_QPA_PLATFORM = "wayland"; # Qt Applications
    GDK_BACKEND = "wayland"; # GTK Applications
    XDG_SESSION_TYPE = "wayland"; # Electron Applications
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  systemd.user.services.wayland-proxy = {
    enable = true;
    description = "Wayland Proxy";
    serviceConfig = with pkgs; {
      # Environment = "WAYLAND_DISPLAY=wayland-1";
      ExecStart = "${wayland-proxy-virtwl}/bin/wayland-proxy-virtwl --virtio-gpu --x-display=0 --xwayland-binary=${xwayland}/bin/Xwayland";
      Restart = "on-failure";
      RestartSec = 5;
    };
    wantedBy = [ "default.target" ];
  };

  environment.systemPackages = with pkgs; [
    xdg-utils
    librewolf
  ];

  hardware.graphics.enable = true;
}
