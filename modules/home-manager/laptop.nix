{ config, lib, ... }:
{
  # Notify at 30 % and, critical, at 15 %
  services.batsignal = lib.mkIf config.machine.laptop {
    enable = true;
    extraArgs = [
      "-w"
      "30"
      "-c"
      "15"
    ];
  };
}
