{ config, lib, pkgs, modulesPath, ... }:

with lib;

{
  environment.memoryAllocator.provider = mkForce "libc";
  environment.extraInit = "umask 0077";

  security = {
    sudo.execWheelOnly = true;

    lockKernelModules = mkDefault false;

    protectKernelImage = mkDefault true;

    allowSimultaneousMultithreading = mkForce true;

    forcePageTableIsolation = mkDefault true;

    # This is required by podman to run containers in rootless mode.
    unprivilegedUsernsClone = mkDefault config.virtualisation.containers.enable;

    virtualisation.flushL1DataCache = mkDefault "always";

    apparmor = {
      enable = mkDefault true;
      killUnconfinedConfinables = mkDefault true;
    };

    rtkit.enable = true;
    polkit.enable = true;
  };

  boot = {
    kernelParams = [
      # Slab/slub sanity checks, redzoning, and poisoning
      "slub_debug=FZP"

      # Don't merge slabs
      "slab_nomerge"

      # Overwrite free'd pages
      "page_poison=1"

      # Enable page allocator randomization
      "page_alloc.shuffle=1"

      # Disable debugfs
      "debugfs=off"
    ];

    blacklistedKernelModules = [
      # Obscure network protocols
      "ax25"
      "netrom"
      "rose"

      # Old or rare or insufficiently audited filesystems
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "f2fs"
      "hfs"
      "hpfs"
      "jfs"
      "minix"
      "nilfs2"
      "ntfs"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
      "ufs"
    ];

    kernel.sysctl = {
      "kernel.yama.ptrace_scope" = mkOverride 500 1;
      # "kernel.unprivileged_userns_clone" = mkDefault true;
      "net.ipv4.conf.default.accept_source_route" = mkDefault 0;
      "kernel.sysrq" = mkDefault 0;
      "kernel.unprivileged_bpf_disabled" = mkDefault 1;
      "kernel.core_uses_pid" = mkDefault 1;
      "dev.tty.ldisc_autoload" = mkDefault 0;

      # Hide kptrs even for processes with CAP_SYSLOG
      "kernel.kptr_restrict" = mkOverride 500 2;

      # Disable bpf() JIT (to eliminate spray attacks)
      "net.core.bpf_jit_enable" = mkDefault false;

      # Disable ftrace debugging
      "kernel.ftrace_enabled" = mkDefault false;

      # Enable strict reverse path filtering (that is, do not attempt to route
      # packets that "obviously" do not belong to the iface's network; dropped
      # packets are logged as martians).
      "net.ipv4.conf.all.log_martians" = mkDefault true;
      "net.ipv4.conf.all.rp_filter" = mkDefault "1";
      "net.ipv4.conf.default.log_martians" = mkDefault true;
      "net.ipv4.conf.default.rp_filter" = mkDefault "1";

      # Ignore broadcast ICMP (mitigate SMURF)
      "net.ipv4.icmp_echo_ignore_broadcasts" = mkDefault true;

      # Ignore incoming ICMP redirects (note: default is needed to ensure that the
      # setting is applied to interfaces added after the sysctls are set)
      "net.ipv4.conf.all.accept_redirects" = mkDefault false;
      "net.ipv4.conf.all.secure_redirects" = mkDefault false;
      "net.ipv4.conf.default.accept_redirects" = mkDefault false;
      "net.ipv4.conf.default.secure_redirects" = mkDefault false;
      "net.ipv6.conf.all.accept_redirects" = mkDefault false;
      "net.ipv6.conf.default.accept_redirects" = mkDefault false;

      # Ignore outgoing ICMP redirects (this is ipv4 only)
      "net.ipv4.conf.all.send_redirects" = mkDefault false;
      "net.ipv4.conf.default.send_redirects" = mkDefault false;
    };
  };
}
