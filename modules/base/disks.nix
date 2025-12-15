{
  mkStr,
  mkBool,
  mkList,
  lib,
  ...
}:
{
  modules.base = {
    options.disks = {
      enable = mkBool false;
      luks = {
        enable = mkBool false;
        device = mkStr null;
        name = mkStr "root";
      };
      boot = {
        device = mkStr null;
        fsType = mkStr "vfat";
        options = mkList lib.types.str [
          "fmask=0022"
          "dmask=0022"
        ];
      };
      root = {
        useTmpfs = mkBool true;
        tmpfsSize = mkStr "2G";
      };
      btrfs = {
        device = mkStr "/dev/mapper/root";
        options = mkList lib.types.str [
          "noatime"
          "compress=zstd"
          "space_cache=v2"
        ];
        subvolumes = {
          nix = mkBool true;
          persist = mkBool true;
          swap = mkBool true;
          tmp = mkBool true;
        };
      };
      swap = {
        enable = mkBool true;
        path = mkStr "/swap/swapfile";
      };
    };

    module =
      { node, lib, ... }:
      lib.mkIf (node.base.enable && node.base.disks.enable) (
        let
          cfg = node.base.disks;
        in
        {
          boot.initrd.luks.devices.${cfg.luks.name} = lib.mkIf cfg.luks.enable {
            device = cfg.luks.device;
          };

          fileSystems."/" =
            if cfg.root.useTmpfs then
              {
                fsType = "tmpfs";
                options = [
                  "defaults"
                  "mode=755"
                  "nodev"
                  "nosuid"
                  "size=${cfg.root.tmpfsSize}"
                ];
              }
            else
              {
                device = cfg.btrfs.device;
                fsType = "btrfs";
                options = [ "subvol=root" ] ++ cfg.btrfs.options;
              };

          fileSystems."/boot" = {
            device = cfg.boot.device;
            fsType = cfg.boot.fsType;
            options = lib.mkIf (cfg.boot.fsType == "vfat") cfg.boot.options;
          };

          fileSystems."/nix" = lib.mkIf cfg.btrfs.subvolumes.nix {
            device = cfg.btrfs.device;
            fsType = "btrfs";
            options = [ "subvol=nix" ] ++ cfg.btrfs.options;
          };

          fileSystems."/persist" = lib.mkIf cfg.btrfs.subvolumes.persist {
            device = cfg.btrfs.device;
            fsType = "btrfs";
            options = [ "subvol=persist" ] ++ cfg.btrfs.options;
            neededForBoot = true;
          };

          fileSystems."/swap" = lib.mkIf cfg.btrfs.subvolumes.swap {
            device = cfg.btrfs.device;
            fsType = "btrfs";
            options = [ "subvol=swap" ] ++ cfg.btrfs.options;
            neededForBoot = true;
          };

          fileSystems."/tmp" = lib.mkIf cfg.btrfs.subvolumes.tmp {
            device = cfg.btrfs.device;
            fsType = "btrfs";
            options = [ "subvol=tmp" ] ++ cfg.btrfs.options;
          };

          swapDevices = lib.mkIf cfg.swap.enable [
            { device = cfg.swap.path; }
          ];
        }
      );
  };
}
