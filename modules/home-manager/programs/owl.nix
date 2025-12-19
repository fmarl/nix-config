{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.owl;
in
{
  options.modules.owl.enable = mkEnableOption "Install and configure owl";

  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.writeShellScriptBin "owl" ''
        if [[ "''$1" == "--help" ]]; then
          echo "Simple tool to export a password within a keepassxc database to a given env variable."
          echo
          echo "owl <secret-name> <env-variable>"
          echo
          echo "Example usage: owl snyk-token SNYK_TOKEN"
          exit 0
        fi

        if [[ -z "''$OWL_DB" ]]; then
          echo "No keepassxc database defined."
          echo "Please specify one as value of the OWL_DB env variable."
          exit 1
        fi

        if [[ -z "''$1" ]]; then
          echo "No secret name given."
          exit 1
        fi

        if [[ -z "''$2" ]]; then
          echo "No env variable name given."
          exit 1
        fi

        KEEPASS_ENTRY="''$(${pkgs.keepassxc}/bin/keepassxc-cli show -s ''$OWL_DB ''$1)"

        ENTRY_PASSWORD="''$(echo "''$KEEPASS_ENTRY" | grep -i 'password:' | cut -d ' ' -f 2)"

        unset KEEPASS_ENTRY

        if [[ -n "''$ENTRY_PASSWORD" ]]; then
          echo "export ''$2=\"''$ENTRY_PASSWORD\""
        fi
      '')
    ];
  };
}
