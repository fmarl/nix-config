{
  pkgs,
  self,
  host,
  user,
  ...
}:
{
  imports = [
    (import ./global {
      inherit
        pkgs
        self
        host
        user
        ;
    })
    ./optional
  ];
}
