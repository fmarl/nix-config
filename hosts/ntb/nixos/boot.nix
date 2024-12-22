{ config, pkgs, lib, ... }:

with lib;

{
  boot = {
    kernelModules = [ "kvm-intel" ];

    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    extraModulePackages = [ ];

    tmp.cleanOnBoot = true;

    # Restrict ptrace() usage to processes with a pre-defined relationship
    # (e.g., parent/child)
    kernel.sysctl = {
      "kernel.yama.ptrace_scope" = mkOverride 500 1;
      "kernel.unprivileged_userns_clone" = mkDefault 1;
      "net.ipv4.conf.default.accept_source_route" = mkDefault 0;
      "kernel.sysrq" = mkDefault 0;
      "kernel.unprivileged_bpf_disabled" = mkDefault 1;
      "kernel.core_uses_pid" = mkDefault 1;
      "dev.tty.ldisc_autoload" = mkDefault 0;
    };
  };
}
