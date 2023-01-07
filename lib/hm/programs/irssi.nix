{ pkgs, ... }:
{
  programs.irssi = {
    enable = true;
    networks =
      {
        libera = {
          type = "IRC";
          nick = "fxttr";
          name = "fxttr";
          server = {
            address = "irc.libera.chat";
            port = 6697;
            autoConnect = false;
          };
          channels = {
            nixos.autoJoin = true;
          };
        };
      };
  };
}
