{ pkgs, ... }:
{
  services = {
    dbus.enable = true;

    pcscd.enable = true;

    pulseaudio.enable = false;
    
    udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
