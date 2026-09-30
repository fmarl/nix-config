{
  services = {
    logrotate.checkConfig = false;

    udev.extraRules = ''
      SUBSYSTEM=="usbmon", GROUP="wireshark", MODE="0640"
    '';
  };
}
