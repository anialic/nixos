{
  mkStr,
  mkBool,
  mkList,
  mkStrList,
  lib,
  ...
}:
{
  modules.base = {
    options.nix = {
      substituters = mkStrList;
      trustedPublicKeys = mkStrList;
      trustedUsers = mkList lib.types.str [ "@wheel" ];
      experimentalFeatures = mkList lib.types.str [
        "nix-command"
        "flakes"
        "ca-derivations"
        "auto-allocate-uids"
        "cgroups"
        "no-url-literals"
        "pipe-operators"
      ];
      gc = {
        automatic = mkBool false;
        dates = mkStr "weekly";
        options = mkStr "--delete-older-than 30d";
      };
    };

    module =
      {
        node,
        pkgs,
        lib,
        ...
      }:
      {
        nix = {
          package = pkgs.nixVersions.latest;
          settings = {
            flake-registry = "/etc/nix/json";
            nix-path = [ "nixpkgs=${pkgs.path}" ];
            substituters = node.base.nix.substituters;
            trusted-public-keys = node.base.nix.trustedPublicKeys;
            trusted-users = node.base.nix.trustedUsers;
            auto-optimise-store = true;
            builders-use-substitutes = true;
            keep-derivations = true;
            auto-allocate-uids = true;
            use-cgroups = true;
            use-xdg-base-directories = true;
            experimental-features = node.base.nix.experimentalFeatures;
          };
          gc = lib.mkIf node.base.nix.gc.automatic {
            automatic = true;
            dates = node.base.nix.gc.dates;
            options = node.base.nix.gc.options;
          };
        };
      };
  };
}
