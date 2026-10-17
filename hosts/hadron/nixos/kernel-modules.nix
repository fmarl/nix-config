# No module loading after boot, so root cannot load code into the kernel. Every
# module needed later has to be loaded at boot; modprobe adds dependencies.
{
  security.lockKernelModules = true;

  boot.kernelModules = [
    # Loaded on this machine on 2026-10-17 (lsmod, without dependencies), so
    # devices plugged in later, e.g. the Logitech receiver, still work
    "aesni_intel"
    "ahci"
    "amd_atl"
    "amdgpu"
    "atkbd"
    "autofs4"
    "blake2b_generic"
    "btrfs"
    "button"
    "cfg80211"
    "configfs"
    "dmi_sysfs"
    "edac_core"
    "edac_mce_amd"
    "efivarfs"
    "evdev"
    "fuse"
    "ghash_clmulni_intel"
    "gigabyte_wmi"
    "gpio_amdpt"
    "hid_generic"
    "hid_logitech_dj"
    "hid_logitech_hidpp"
    "i2c_piix4"
    "input_leds"
    "intel_rapl_msr"
    "joydev"
    "k10temp"
    "kvm_amd"
    "loop"
    "mac_hid"
    "mousedev"
    "nft_ct"
    "nft_fib_inet"
    "nls_cp437"
    "nls_iso8859_1"
    "nvme"
    "onboard_usb_dev"
    "overlay"
    "polyval_clmulni"
    "r8169"
    "rapl"
    "realtek"
    "rtc_cmos"
    "sch_fq_codel"
    "sd_mod"
    "snd_hda_codec_alc662"
    "snd_hda_codec_atihdmi"
    "snd_hda_intel"
    "snd_hrtimer"
    "snd_seq_dummy"
    "sp5100_tco"
    "thermal"
    "tiny_power_button"
    "tun"
    "vfat"
    "wmi_bmof"
    "xhci_pci"
    "zfs"
    "zram"

    # Loaded on demand
    "wireguard" # Mullvad
    "nft_reject_inet" # Mullvad and the firewall
    "nft_socket" # Mullvad split tunneling
    "nft_limit"
    "nft_masq" # rootful podman, rootless uses pasta
    "nft_chain_nat"
    "veth"
    "bridge"
    "usb_storage"
    "uas"
    "exfat"
    "snd_usb_audio"
  ];
}
