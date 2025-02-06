{
  programs.nix-ld.enable = true;
  
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    settings = {
      trusted-users = [ "root" "@wheel" ];
      allowed-users = [ "@wheel" ];
    };

    extraOptions = "experimental-features = nix-command flakes";

    optimise.automatic = true;
  };
}
