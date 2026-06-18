{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.modules.hawk;
in
{
  options.modules.hawk.enable = lib.mkEnableOption "Install and configure hawk";

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.hostPlatform.isDarwin;
        message = "modules.hawk is macOS-only (depends on /usr/bin/security).";
      }
    ];

    home.packages = [
      (pkgs.writeShellScriptBin "hawk" ''
        set -euo pipefail

        if [[ "''${1:-}" == "--help" ]]; then
          echo "Simple tool to export a secret from the macOS Keychain to a given env variable."
          echo
          echo "hawk <service-name> <env-variable>"
          echo
          echo "Example usage: hawk snyk-recommendations SNYK_TOKEN"
          echo
          echo "Alternative: Use hawk to wrap a program and inject the secret into its process environment."
          echo
          echo "Example usage: hawk snyk-recommendations SNYK_TOKEN ./get-issues.py"
          exit 0
        fi

        if [[ -z "''${1:-}" ]]; then
          echo "No service name given." >&2
          exit 1
        fi

        if [[ -z "''${2:-}" ]]; then
          echo "No env variable name given." >&2
          exit 1
        fi

        SERVICE_NAME="$1"
        VARIABLE_NAME="$2"
        ENTRY_PASSWORD="$(/usr/bin/security find-generic-password -s "$SERVICE_NAME" -a "$USER" -w 2>/dev/null)" || {
          echo "No keychain entry found for service \"$SERVICE_NAME\" and account \"$USER\"." >&2
          echo "Create one with:" >&2
          echo "  security add-generic-password -s \"$SERVICE_NAME\" -a \"$USER\" -w" >&2
          exit 1
        }

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
