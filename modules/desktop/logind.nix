{ mkStr, ... }:
{
  modules.desktop = {
    options.logind = {
      handlePowerKey = mkStr "suspend";
      handleLidSwitch = mkStr "sleep";
    };

    module =
      { node, ... }:
      {
        services.logind.settings.Login = {
          HandlePowerKey = node.desktop.logind.handlePowerKey;
          HandleLidSwitch = node.desktop.logind.handleLidSwitch;
        };
      };
  };
}
