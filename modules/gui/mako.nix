{
  mkStr,
  mkBool,
  mkInt,
  mkEnable,
  lib,
  ...
}:
{
  modules.gui = {
    options.mako = {
      enable = mkEnable "Mako notification daemon";
      autostart = mkBool true;
      backgroundColor = mkStr "#2e34407f";
      width = mkInt 420;
      height = mkInt 120;
      borderSize = mkInt 3;
      borderRadius = mkInt 12;
      maxIconSize = mkInt 64;
      defaultTimeout = mkInt 5000;
      margin = mkInt 12;
      padding = mkStr "12,20";
      urgency = {
        low = mkStr "#cccccc";
        normal = mkStr "#99c0d0";
        critical = mkStr "#bf616a";
      };
    };

    module =
      {
        node,
        pkgs,
        lib,
        ...
      }:
      lib.mkIf (node.gui.enable && node.gui.mako.enable) (
        let
          makoConfig = pkgs.writeText "config" ''
            sort=-time
            layer=overlay
            background-color=${node.gui.mako.backgroundColor}
            width=${toString node.gui.mako.width}
            height=${toString node.gui.mako.height}
            border-size=${toString node.gui.mako.borderSize}
            border-color=${node.gui.mako.urgency.normal}
            border-radius=${toString node.gui.mako.borderRadius}
            max-icon-size=${toString node.gui.mako.maxIconSize}
            default-timeout=${toString node.gui.mako.defaultTimeout}
            ignore-timeout=0
            margin=${toString node.gui.mako.margin}
            padding=${node.gui.mako.padding}

            [urgency=low]
            border-color=${node.gui.mako.urgency.low}

            [urgency=normal]
            border-color=${node.gui.mako.urgency.normal}

            [urgency=critical]
            border-color=${node.gui.mako.urgency.critical}
            default-timeout=0
          '';
        in
        {
          environment.systemPackages = [ pkgs.mako ];
          environment.etc."xdg/mako/config".source = makoConfig;

          systemd.user.services.mako = lib.mkIf node.gui.mako.autostart {
            enable = true;
            description = "Mako notification daemon";
            documentation = [ "man:mako(5)" ];
            partOf = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            wantedBy = [ "graphical-session.target" ];
            serviceConfig = {
              Type = "dbus";
              BusName = "org.freegui.Notifications";
              ExecStart = "${pkgs.mako}/bin/mako";
              ExecReload = "${pkgs.mako}/bin/makoctl reload";
              Restart = "on-failure";
              RestartSec = 3;
            };
          };
        }
      );
  };
}
