{
  boot = {
    # Full preemption for desktop latency, the kernel defaults to lazy
    kernelParams = [ "preempt=full" ];

    tmp.useTmpfs = true;

    specialFileSystems."/dev/shm".options = [ "noexec" ];

    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  # Large builds would fill the /tmp tmpfs
  systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp";
}
