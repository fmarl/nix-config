{
  zramSwap.enable = true;

  # Tuned for zram-only swap (https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram)
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.page-cluster" = 0;
  };

  # Kill the offending unit under memory pressure instead of freezing
  systemd.oomd.enableUserSlices = true;
}
