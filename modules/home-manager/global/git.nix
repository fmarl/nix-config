{
  user,
  users,
  ...
}:
let
  me = users.${user};
in
{
  programs.git = {
    enable = true;

    ignores = [
      ".direnv/"
      ".cache/"
    ];

    settings = {
      user = {
        name = me.fullName;
        email = me.email;
      };

      core = {
        editor = "emacsclient -c -a '' -w";
        whitespace = "-trailing-space";
      };

      log.abbrevCommit = true;
    };

    signing = {
      signByDefault = false;
      key = me.gpgKey;
    };
  };
}
