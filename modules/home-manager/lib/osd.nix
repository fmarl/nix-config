# Volume and brightness changes shown as a progress notification that replaces
# the previous one
{ pkgs }:
let
  osdScript =
    name: text:
    pkgs.writeShellScript name ''
      ${text}
      id_file="$XDG_RUNTIME_DIR/${name}"
      id=$(cat "$id_file" 2>/dev/null)
      ${pkgs.libnotify}/bin/notify-send -a osd -u low -t 1500 -p -h "int:value:''${percent:-0}" \
          -r "''${id:-0}" "$title" >"$id_file.$$" &&
          mv "$id_file.$$" "$id_file"
      rm -f "$id_file.$$"
    '';

  wpctl = "${pkgs.wireplumber}/bin/wpctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
in
{
  volume = osdScript "volume-osd" ''
    ${wpctl} "$@"
    volume=$(${wpctl} get-volume "$2")
    percent=$(echo "$volume" | ${pkgs.gawk}/bin/awk '{ print int($2 * 100 + 0.5) }')
    case "$2" in
        *SOURCE*) title=Mikrofon ;;
        *) title=Lautstärke ;;
    esac
    case "$volume" in
        *MUTED*) title="$title (stumm)" ;;
    esac
  '';

  brightness = osdScript "brightness-osd" ''
    ${brightnessctl} -q --class=backlight set "$1"
    percent=$(${brightnessctl} -m --class=backlight | cut -d, -f4 | tr -d %)
    title=Helligkeit
  '';
}
