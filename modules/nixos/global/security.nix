{ lib, pkgs, ... }:
let
  # Rarely used and historically vulnerable kernel modules
  disabledModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"
    "x25"
    "appletalk"
    "psnap"
    "can"
    "atm"
    "sctp"
    "rds"
    "tipc"
    "n_hdlc"
    "ieee802154"

    # FireWire and Thunderbolt (DMA attacks)
    "firewire_core"
    "firewire_ohci"
    "firewire_sbp2"
    "firewire_net"
    "thunderbolt"

    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "freevxfs"
    "f2fs"
    "gfs2"
    "hfs"
    "hfsplus"
    "hpfs"
    "jffs2"
    "jfs"
    "minix"
    "nilfs2"
    "ocfs2"
    "omfs"
    "qnx4"
    "qnx6"
    "ufs"
  ];
in
{
  security = {
    # umask for every session (login, greetd, sshd), not only login shells
    pam.enableUMask = true;
    loginDefs.settings.UMASK = "077";

    sudo = {
      execWheelOnly = true;

      # Files created via sudo (e.g. below /etc) stay world readable
      extraConfig = ''
        Defaults umask=0022
        Defaults umask_override
      '';
    };

    # Setuid wrappers nobody needs. newuidmap/newgidmap stay for rootless
    # podman, fusermount3 for FUSE.
    wrappers =
      lib.genAttrs
        [
          "chsh"
          "fusermount"
          "mount"
          "newgrp"
          "passwd"
          "sg"
          "su"
          "umount"
        ]
        (_: {
          enable = false;
        });

    protectKernelImage = lib.mkDefault true;

    apparmor = {
      enable = lib.mkDefault true;
      killUnconfinedConfinables = lib.mkDefault true;
    };

    rtkit.enable = true;
    polkit.enable = true;
  };

  boot = {
    kernelParams = [
      "slab_nomerge"

      "init_on_free=1"

      "page_alloc.shuffle=1"

      "debugfs=off"

      # Turn off bus mastering before the IOMMU is up
      "efi=disable_early_pci_dma"

      # Invalidate IOTLB entries synchronously
      "iommu.strict=1"

      # No legacy vsyscall page at a fixed address
      "vsyscall=none"
    ];

    # Blacklisting only stops autoloading, "install … false" also blocks explicit modprobe
    blacklistedKernelModules = disabledModules;
    extraModprobeConfig = lib.concatMapStrings (
      m: "install ${m} ${pkgs.coreutils}/bin/false\n"
    ) disabledModules;

    kernel.sysctl = {
      # Only root may ptrace
      "kernel.yama.ptrace_scope" = lib.mkOverride 500 2;
      "vm.mmap_rnd_bits" = lib.mkDefault 32;
      "net.core.bpf_jit_harden" = lib.mkDefault 2;
      # io_uring has been a steady source of kernel exploits
      "kernel.io_uring_disabled" = lib.mkDefault 2;
      "net.ipv4.conf.default.accept_source_route" = lib.mkDefault 0;
      "kernel.sysrq" = lib.mkDefault 0;
      "kernel.unprivileged_bpf_disabled" = lib.mkDefault 1;
      "kernel.core_uses_pid" = lib.mkDefault 1;
      "dev.tty.ldisc_autoload" = lib.mkDefault 0;
      "fs.protected_fifos" = lib.mkDefault 2;
      "fs.protected_regular" = lib.mkDefault 2;
      "fs.suid_dumpable" = lib.mkDefault 0;
      "net.ipv4.tcp_rfc1337" = lib.mkDefault 1;

      # Hide kptrs even for processes with CAP_SYSLOG
      "kernel.kptr_restrict" = lib.mkOverride 500 2;

      # Disable bpf() JIT (to eliminate spray attacks)
      "net.core.bpf_jit_enable" = lib.mkDefault false;

      "kernel.ftrace_enabled" = lib.mkDefault false;

      # Enable strict reverse path filtering (that is, do not attempt to route
      # packets that "obviously" do not belong to the iface's network; dropped
      # packets are logged as martians).
      "net.ipv4.conf.all.log_martians" = lib.mkDefault true;
      "net.ipv4.conf.all.rp_filter" = lib.mkDefault "1";
      "net.ipv4.conf.default.log_martians" = lib.mkDefault true;
      "net.ipv4.conf.default.rp_filter" = lib.mkDefault "1";

      # Ignore broadcast ICMP (mitigate SMURF)
      "net.ipv4.icmp_echo_ignore_broadcasts" = lib.mkDefault true;

      # Ignore incoming ICMP redirects (note: default is needed to ensure that the
      # setting is applied to interfaces added after the sysctls are set)
      "net.ipv4.conf.all.accept_redirects" = lib.mkDefault false;
      "net.ipv4.conf.all.secure_redirects" = lib.mkDefault false;
      "net.ipv4.conf.default.accept_redirects" = lib.mkDefault false;
      "net.ipv4.conf.default.secure_redirects" = lib.mkDefault false;
      "net.ipv6.conf.all.accept_redirects" = lib.mkDefault false;
      "net.ipv6.conf.default.accept_redirects" = lib.mkDefault false;

      # Ignore outgoing ICMP redirects (this is ipv4 only)
      "net.ipv4.conf.all.send_redirects" = lib.mkDefault false;
      "net.ipv4.conf.default.send_redirects" = lib.mkDefault false;
    };
  };
}
