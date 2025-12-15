{
  mkStr,
  mkStrList,
  mkAttrsOf,
  mkEither,
  mkSub,
  mkListOf,
  lib,
  inputs,
  ...
}:
{
  modules.preservation = {
    target = "nixos";

    options = {
      persistPath = mkStr "/persist";
      users = mkAttrsOf (
        lib.types.submodule {
          options = {
            files = mkStrList;
            directories = mkListOf (
              lib.types.either lib.types.str (
                lib.types.submodule {
                  options = {
                    directory = mkStr "";
                    mode = mkStr "0755";
                  };
                }
              )
            );
          };
        }
      );
    };

    module =
      { node, lib, ... }:
      {
        imports = [ inputs.preservation.nixosModules.preservation ];

        config = lib.mkIf node.preservation.enable {
          preservation = {
            enable = true;
            preserveAt.${node.preservation.persistPath} = {
              users = lib.mapAttrs (username: userCfg: {
                inherit (userCfg) files;
                directories = map (
                  d: if builtins.isString d then d else { inherit (d) directory mode; }
                ) userCfg.directories;
              }) node.preservation.users;
            };
          };
        };
      };
  };
}
