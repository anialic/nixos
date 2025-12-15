{ mkList, mkEnable, lib, ... }:
{
  modules.desktop = {
    options.fonts = {
      enable = mkEnable "font configuration";
      packages = mkList lib.types.str [
        "roboto"
        "noto-fonts"
        "noto-fonts-cjk-sans"
        "noto-fonts-cjk-serif"
        "noto-fonts-color-emoji"
        "jetbrains-mono"
      ];
      nerdFonts = mkList lib.types.str [
        "jetbrains-mono"
        "roboto-mono"
      ];
      defaultFonts = {
        serif = mkList lib.types.str [
          "Noto Serif"
          "Noto Serif CJK SC"
        ];
        sansSerif = mkList lib.types.str [
          "Noto Sans"
          "Noto Sans CJK SC"
        ];
        monospace = mkList lib.types.str [ "JetBrains Mono" ];
        emoji = mkList lib.types.str [ "Noto Color Emoji" ];
      };
    };

    module =
      {
        node,
        pkgs,
        lib,
        ...
      }:
      lib.mkIf node.desktop.fonts.enable {
        fonts = {
          enableDefaultPackages = false;
          packages =
            (map (p: pkgs.${p}) node.desktop.fonts.packages)
            ++ (map (f: pkgs.nerd-fonts.${f}) node.desktop.fonts.nerdFonts);
          fontconfig = {
            enable = true;
            defaultFonts = {
              inherit (node.desktop.fonts.defaultFonts)
                serif
                sansSerif
                monospace
                emoji
                ;
            };
          };
        };
      };
  };
}
