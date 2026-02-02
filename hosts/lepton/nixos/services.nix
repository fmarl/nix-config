{ pkgs, ... }:
{
  services = {
    logrotate.checkConfig = false;
    
    dbus.enable = true;

    pcscd.enable = true;

    pulseaudio.enable = false;

    udev = {
      extraRules = ''
        SUBSYSTEM=="usbmon", GROUP="wireshark", MODE="0640"
      '';

      packages = with pkgs; [
        yubikey-personalization
        libu2f-host
      ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
