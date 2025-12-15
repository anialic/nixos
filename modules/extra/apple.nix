{
  mkPath,
  mkBool,
  mkInt,
  lib,
  inputs,
  ...
}:
{
  modules.apple = {
    target = "nixos";

    options = {
      peripheralFirmwareDirectory = mkPath null;
      setupAsahiSound = mkBool true;
      batteryChargeLimit = mkInt null;
    };

    module =
      {
        node,
        lib,
        ...
      }:
      {
        imports = [ inputs.apple-silicon-support.nixosModules.apple-silicon-support ];

        hardware.asahi = {
          setupAsahiSound = node.apple.setupAsahiSound;
        }
        // lib.optionalAttrs (node.apple.peripheralFirmwareDirectory != null) {
          peripheralFirmwareDirectory = node.apple.peripheralFirmwareDirectory;
        };

        boot = {
          kernelParams = [ "apple_dcp.show_notch=1" ];
        };

        services.udev.extraRules = lib.mkIf (node.apple.batteryChargeLimit != null) ''
          SUBSYSTEM=="power_supply", KERNEL=="macsmc-battery", ATTR{charge_control_end_threshold}="${toString node.apple.batteryChargeLimit}"
        '';
      };
  };
}
