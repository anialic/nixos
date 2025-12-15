{
  mkStr,
  mkBool,
  mkInt,
  mkEnable,
  lib,
  ...
}:
{
  modules.desktop = {
    options = {
      kmscon = {
        enable = mkBool true;
        font = mkStr "JetBrainsMono Nerd Font";
        fontPackage = mkStr "nerd-fonts.jetbrains-mono";
        fontSize = mkInt 14;
      };

      bluetooth.enable = mkEnable "bluetooth";

      audio.enable = mkEnable "PipeWire audio";

      power = {
        enable = mkEnable "power management";
        handlePowerKey = mkStr "suspend";
        handleLidSwitch = mkStr "suspend";
      };
    };

    module =
      {
        node,
        pkgs,
        lib,
        ...
      }:
      let
        cfg = node.desktop;
        getFontPkg = path: lib.foldl' (acc: part: acc.${part}) pkgs (lib.splitString "." path);
      in
      lib.mkIf cfg.enable {
        services = {
          kmscon = lib.mkIf cfg.kmscon.enable {
            enable = true;
            fonts = [
              {
                name = cfg.kmscon.font;
                package = getFontPkg cfg.kmscon.fontPackage;
              }
            ];
            extraConfig = "font-size=${toString cfg.kmscon.fontSize}";
          };

          udisks2.enable = true;
          udev.packages = [ pkgs.usbutils ];

          pipewire = lib.mkIf cfg.audio.enable {
            enable = true;
            alsa.enable = true;
            pulse.enable = true;
          };

          logind = lib.mkIf cfg.power.enable {
            lidSwitch = cfg.power.handleLidSwitch;
            extraConfig = ''
              HandlePowerKey=${cfg.power.handlePowerKey}
            '';
          };

          upower.enable = cfg.power.enable;
        };

        hardware.bluetooth = lib.mkIf cfg.bluetooth.enable {
          enable = true;
          powerOnBoot = true;
          settings.General.Experimental = true;
        };

        security.rtkit.enable = true;
      };
  };
}
