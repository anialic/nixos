{
  mkStr,
  mkBool,
  mkList,
  mkStrList,
  mkAttrsOf,
  lib,
  ...
}:
{
  modules.base = {
    options.users = mkAttrsOf (
      lib.types.submodule {
        options = {
          hashedPassword = mkStr null;
          extraGroups = mkList lib.types.str [ "wheel" ];
          shell = mkStr "bash";
          packages = mkStrList;
          authorizedKeys = mkStrList;
          linger = mkBool false;
          homeFiles = mkAttrsOf lib.types.path;
        };
      }
    );

    module =
      {
        node,
        pkgs,
        lib,
        ...
      }:
      let
        readDirRecursive =
          dir:
          lib.pipe (builtins.readDir dir) [
            (lib.mapAttrsToList (
              name: type:
              if type == "directory" then
                map (p: "${name}/${p}") (readDirRecursive (dir + "/${name}"))
              else
                [ name ]
            ))
            lib.flatten
          ];

        mkUserRules =
          username: userCfg:
          lib.pipe userCfg.homeFiles [
            (lib.mapAttrsToList (
              target: source:
              let
                sourceType = builtins.readFileType source;
              in
              if sourceType == "directory" then
                map (relPath: "L+ %h/${target}/${relPath} - - - - ${source}/${relPath}") (readDirRecursive source)
              else
                [ "L+ %h/${target} - - - - ${source}" ]
            ))
            lib.flatten
          ];
      in
      lib.mkIf (node.base.users != { }) {
        users.mutableUsers = false;

        users.users = lib.mapAttrs (username: userCfg: {
          isNormalUser = true;
          inherit (userCfg) hashedPassword extraGroups linger;
          packages = map (p: pkgs.${p}) userCfg.packages;
          shell = pkgs.${userCfg.shell};
          openssh.authorizedKeys.keys = userCfg.authorizedKeys;
        }) node.base.users;

        systemd.user.tmpfiles.users = lib.mapAttrs (username: userCfg: {
          rules = mkUserRules username userCfg;
        }) (lib.filterAttrs (_: u: u.homeFiles != { }) node.base.users);
      };
  };
}
