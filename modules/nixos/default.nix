{
  self,
  host,
  ...
}:
{
  imports = [
    ./optional
    (import ./global { inherit self host; })
  ];
}
