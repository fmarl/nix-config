{ lib }:
let
  palettes = {
    ef-owl = {
      dark = true;
      colors = {
        bg_0 = "292c2f";
        bg_1 = "373b3d";
        bg_2 = "40474b";
        bg_popup = "33363a";
        bg_region = "404f66";
        bg_accent = "4f509f";
        bg_active = "60676b";
        border = "4f5f66";
        cursor = "afe6ef";
        dim_0 = "9a94a4";
        fg_0 = "d0d0d0";
        fg_1 = "aab9af";

        red = "d67869";
        green = "70bb70";
        yellow = "c09f6f";
        blue = "80a4e0";
        magenta = "e5a0ea";
        cyan = "8fb8ea";
        orange = "df885f";
        violet = "a0a0ef";

        br_red = "e4959f";
        br_green = "60bd90";
        br_yellow = "cf9f90";
        br_blue = "72aff0";
        br_magenta = "cfa0e8";
        br_cyan = "7ac0b9";
        br_orange = "d1a45f";
        br_violet = "d389af";
      };
    };

    modus-operandi-tinted = {
      dark = false;
      colors = {
        bg_0 = "fbf7f0";
        bg_1 = "efe9dd";
        bg_2 = "dfd5cf";
        bg_popup = "f6eddd";
        bg_region = "c2bcb5";
        bg_accent = "bfc9ff";
        bg_active = "c9b9b0";
        border = "9f9690";
        cursor = "d00000";
        dim_0 = "595959";
        fg_0 = "000000";
        fg_1 = "193668";

        red = "a60000";
        green = "006300";
        yellow = "6d5000";
        blue = "0031a9";
        magenta = "721045";
        cyan = "00598b";
        orange = "972500";
        violet = "3546c2";

        br_red = "a0132f";
        br_green = "00603f";
        br_yellow = "602938";
        br_blue = "0000b0";
        br_magenta = "531ab6";
        br_cyan = "005f5f";
        br_orange = "894000";
        br_violet = "8f0075";
      };
    };
  };

  # In the order the kernel expects them
  consoleColors = [
    {
      name = "black";
      color = "bg_0";
    }
    {
      name = "red";
      color = "red";
    }
    {
      name = "green";
      color = "green";
    }
    {
      name = "yellow";
      color = "yellow";
    }
    {
      name = "blue";
      color = "blue";
    }
    {
      name = "magenta";
      color = "magenta";
    }
    {
      name = "cyan";
      color = "cyan";
    }
    {
      name = "gray";
      color = "fg_0";
    }
    {
      name = "darkgray";
      color = "dim_0";
    }
    {
      name = "lightred";
      color = "br_red";
    }
    {
      name = "lightgreen";
      color = "br_green";
    }
    {
      name = "lightyellow";
      color = "br_yellow";
    }
    {
      name = "lightblue";
      color = "br_blue";
    }
    {
      name = "lightmagenta";
      color = "br_magenta";
    }
    {
      name = "lightcyan";
      color = "br_cyan";
    }
    {
      name = "white";
      color = "fg_1";
    }
  ];

  round = x: builtins.floor (x + 0.5);

  style = {
    barHeight = 28;
    cursorTheme = "Numix-Cursor";
    cursorSize = 24;
    monospaceFont = "Aporetic Sans Mono";
    sansFont = "Inter";
    cornerRadius = 10;
    smallCornerRadius = 6;
    smallSpacing = 4;
    spacing = 8;
    largeSpacing = 12;
    popupAlpha = 0.95;
  };

  # The theme NAME with its colors and the functions to format them
  mk =
    name:
    let
      inherit (palettes.${name}) dark colors;
    in
    rec {
      inherit
        name
        dark
        colors
        style
        ;

      raw = color: colors.${color} or (throw "unknown theme color ${color}");

      color = name: "#${raw name}";

      channels =
        name:
        map (start: lib.fromHexString (builtins.substring start 2 (raw name))) [
          0
          2
          4
        ];

      rgba =
        name: alpha: "rgba(${lib.concatMapStringsSep ", " toString (channels name)}, ${toString alpha})";

      # #rrggbbaa
      hexAlpha =
        name: alpha:
        color name + lib.fixedWidthString 2 "0" (lib.toLower (lib.toHexString (round (alpha * 255))));

      hairline = hexAlpha "fg_0" 0.1;

      # black is the background, gray the foreground
      console = map (
        { name, color }: raw (if name == "white" && dark then "fg_0" else color)
      ) consoleColors;

      consoleName =
        color:
        (lib.findFirst (c: c.color == color) (throw "no console color for ${color}") consoleColors).name;
    };
in
{
  names = lib.attrNames palettes;
  inherit mk;
}
