{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.modules.owl;
in
{
  options.modules.owl.enable = lib.mkEnableOption "Install and configure owl";

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.writeShellScriptBin "owl" ''
        set -euo pipefail

        if [[ "''${1:-}" == "--help" ]]; then
          echo "Simple tool to export a password within a keepassxc database to a given env variable."
          echo
          echo "owl <secret-name> <env-variable>"
          echo
          echo "Example usage: owl snyk-token SNYK_TOKEN"
          echo
          echo "Alternative: Use owl to wrap a program and inject the secret into its process environment."
          echo
          echo "Example usage: owl snyk-token SNYK_TOKEN ./get-issues.py"
          exit 0
        fi

        if [[ -z "''${OWL_DB:-}" ]]; then
          echo "No keepassxc database defined." >&2
          echo "Please specify one as value of the OWL_DB env variable." >&2
          exit 1
        fi

        if [[ -z "''${1:-}" ]]; then
          echo "No secret name given." >&2
          exit 1
        fi

        if [[ -z "''${2:-}" ]]; then
          echo "No env variable name given." >&2
          exit 1
        fi

        SECRET_NAME="$1"
        VARIABLE_NAME="$2"
        ENTRY_PASSWORD="keepassxc-cli show -s -a password "$OWL_DB" "$SECRET_NAME")"

        if [[ -n "$ENTRY_PASSWORD" ]]; then
          if [[ -z "''${3:-}" ]]; then
            echo "export $VARIABLE_NAME=\"$ENTRY_PASSWORD\""
          else
            shift 2
            env -i "$VARIABLE_NAME=$ENTRY_PASSWORD" PATH="$PATH" "$@"
          fi
        fi
      '')
    ];
  };
}
