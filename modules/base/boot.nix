{
  mkStr,
  mkBool,
  mkInt,
  mkList,
  mkAttrs,
  lib,
  ...
}:
{
  modules.base = {
    options.boot = {
      kernelPackages = mkStr "linuxPackages_latest";
      loader = {
        timeout = mkInt 1;
        efi.canTouchEfiVariables = mkBool true;
      };
      initrd = {
        availableKernelModules = mkList lib.types.str [ ];
        kernelModules = mkList lib.types.str [ ];
      };
      kernelModules = mkList lib.types.str [ ];
      kernelParams = mkList lib.types.str [ ];
      extraModulePackages = mkList lib.types.str [ ];
      enableZswap = mkBool true;
      tmp = {
        useTmpfs = mkBool false;
        tmpfsSize = mkStr null;
        tmpfsHugeMemoryPages = mkStr "advise";
      };
      plymouth.enable = mkBool false;
      enableContainers = mkBool false;
      sysctl = mkAttrs { };
    };

    module =
      {
        node,
        pkgs,
        config,
        lib,
        ...
      }:
      let
        cfg = node.base.boot;

        zswapParams = [
          "zswap.enabled=1"
          "zswap.compressor=zstd"
          "zswap.max_pool_percent=25"
          "zswap.zpool=zsmalloc"
        ];

        silentParams = [
          "quiet"
          "loglevel=3"
          "udev.log_level=3"
          "rd.udev.log_level=3"
        ];
      in
      {
        boot = {
          consoleLogLevel = 3;
          kernelPackages = lib.mkDefault pkgs.${cfg.kernelPackages};
          kernelModules = [ "tcp_bbr" ] ++ cfg.kernelModules;
          kernelParams = silentParams ++ lib.optionals cfg.enableZswap zswapParams ++ cfg.kernelParams;
          extraModulePackages = map (p: config.boot.kernelPackages.${p}) cfg.extraModulePackages;

          kernel.sysctl = cfg.sysctl // {
            "net.core.default_qdisc" = "cake";
            "net.ipv4.tcp_congestion_control" = "bbr";
          };

          loader = {
            systemd-boot.enable = true;
            systemd-boot.configurationLimit = 10;
            timeout = cfg.loader.timeout;
            efi.canTouchEfiVariables = cfg.loader.efi.canTouchEfiVariables;
          };

          initrd = {
            systemd.enable = true;
            availableKernelModules = cfg.initrd.availableKernelModules;
            kernelModules = cfg.initrd.kernelModules;
          };

          tmp = {
            useTmpfs = cfg.tmp.useTmpfs;
            tmpfsHugeMemoryPages = cfg.tmp.tmpfsHugeMemoryPages;
            cleanOnBoot = lib.mkDefault (!cfg.tmp.useTmpfs);
          }
          // lib.optionalAttrs (cfg.tmp.tmpfsSize != null) {
            tmpfsSize = cfg.tmp.tmpfsSize;
          };

          plymouth.enable = cfg.plymouth.enable;
          enableContainers = lib.mkDefault cfg.enableContainers;
        };
      };
  };
}
