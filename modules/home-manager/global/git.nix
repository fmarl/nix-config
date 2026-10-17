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
      ".env*"
    ];

    settings = {
      user = {
        name = me.fullName;
        inherit (me) email;
      };

      core = {
        editor = "emacsclient -c -a '' -w";
        whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        autocrlf = false;
        safecrlf = true;
      };

      safe.bareRepository = "explicit";

      log.abbrevCommit = true;

      pull.rebase = true;

      diff = {
        renames = "copies";
        algorithm = "patience";
        context = 3;
      };

      color.ui = "auto";

      alias = {
        co = "checkout";
        st = "status";
        ci = "commit";
        br = "branch";
        lg = "log --graph --oneline --decorate --all";
        # Push origin to Codeberg and GitHub
        mirror = "!f() { r=$(git remote get-url origin | sed 's|.*fmarl/||; s|\\.git$||'); git config --unset-all remote.origin.pushurl; git remote set-url --add --push origin codeberg.org:fmarl/$r && git remote set-url --add --push origin git@github.com:fmarl/$r.git; }; f";
      };
    };

    signing = {
      signByDefault = true;
      format = "openpgp";
      key = me.gpgKey;
    };
  };
}
