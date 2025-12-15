{
  mkStr,
  mkBool,
  mkEnable,
  mkListOf,
  lib,
  ...
}:
{
  modules.gui = {
    target = "nixos";

    options.fcitx5 = {
      enable = mkEnable "Fcitx5 input method";
      theme = mkStr "FluentDark-solid";
      hotkeys = {
        trigger = mkStr "Control+space";
        activate = mkStr "VoidSymbol";
        deactivate = mkStr "VoidSymbol";
        altTrigger = mkStr "Shift_L";
      };
      behavior = {
        allowInputMethodForPassword = mkBool true;
        showPreeditForPassword = mkBool true;
      };
      addons = mkListOf lib.types.package;
    };

    module =
      {
        node,
        pkgs,
        lib,
        ...
      }:
      lib.mkIf (node.gui.enable && node.gui.fcitx5.enable) {
        i18n.inputMethod = {
          enable = true;
          type = "fcitx5";
          fcitx5 = {
            addons =
              with pkgs;
              [
                fcitx5-fluent
                fcitx5-gtk
                kdePackages.fcitx5-chinese-addons
                fcitx5-pinyin-zhwiki
              ]
              ++ node.gui.fcitx5.addons;
            settings = {
              addons = {
                classicui.globalSection.Theme = node.gui.fcitx5.theme;
                pinyin.globalSection.FirstRun = "False";
              };
              inputMethod = {
                "Groups/0" = {
                  Name = "Default";
                  "Default Layout" = "us";
                  DefaultIM = "keyboard-us";
                };
                "Groups/0/Items/0" = {
                  Name = "keyboard-us";
                  Layout = "";
                };
                "Groups/0/Items/1" = {
                  Name = "pinyin";
                  Layout = "";
                };
              };
              globalOptions = {
                "Hotkey/TriggerKeys"."0" = node.gui.fcitx5.hotkeys.trigger;
                "Hotkey/ActivateKeys"."0" = node.gui.fcitx5.hotkeys.activate;
                "Hotkey/DeactivateKeys"."0" = node.gui.fcitx5.hotkeys.deactivate;
                "Hotkey/AltTriggerKeys"."0" = node.gui.fcitx5.hotkeys.altTrigger;
                "Hotkey/EnumerateGroupForwardKeys"."0" = "VoidSymbol";
                "Hotkey/EnumerateGroupBackwardKeys"."0" = "VoidSymbol";
                Behavior = {
                  AllowInputMethodForPassword = node.gui.fcitx5.behavior.allowInputMethodForPassword;
                  ShowPreeditForPassword = node.gui.fcitx5.behavior.showPreeditForPassword;
                };
              };
            };
            waylandFrontend = true;
            ignoreUserConfig = true;
          };
        };
      };
  };
}
