{
  mkStr,
  mkBool,
  mkAttrs,
  mkEnable,
  lib,
  ...
}:
{
  modules.cli = {
    options.git = {
      enable = mkEnable "git";
      userName = mkStr "";
      userEmail = mkStr "";
      defaultBranch = mkStr "main";
      lfs = mkBool true;
      signing = {
        enable = mkBool false;
        key = mkStr "~/.ssh/id_ed25519";
        format = mkStr "ssh";
      };
      pull.rebase = mkBool true;
      merge = {
        conflictStyle = mkStr "diff3";
        tool = mkStr "vimdiff";
      };
      extraConfig = mkAttrs { };
    };

    module =
      {
        node,
        pkgs,
        lib,
        ...
      }:
      lib.mkIf node.cli.git.enable (
        let
          cfg = node.cli.git;

          gitPackage = if cfg.lfs then pkgs.git-lfs else pkgs.git;

          baseConfig = {
            init.defaultBranch = cfg.defaultBranch;
            pull.rebase = cfg.pull.rebase;
            merge = {
              conflictStyle = cfg.merge.conflictStyle;
              tool = cfg.merge.tool;
            };
            mergetool = {
              keepBackup = false;
              keepTemporaries = false;
              writeToTemp = true;
            };
            fetch.prune = true;
            credential.helper = "store";
          };

          userConfig = lib.optionalAttrs (cfg.userName != "" && cfg.userEmail != "") {
            user = {
              name = cfg.userName;
              email = cfg.userEmail;
            };
          };

          signingConfig = lib.optionalAttrs cfg.signing.enable {
            commit.gpgSign = true;
            gpg.format = cfg.signing.format;
            user.signingKey = cfg.signing.key;
          };
        in
        {
          programs.git = {
            enable = true;
            package = gitPackage;
            config = lib.mkMerge [
              baseConfig
              userConfig
              signingConfig
              cfg.extraConfig
            ];
          };

          environment.systemPackages = lib.optionals cfg.lfs [ pkgs.git-lfs ];
        }
      );
  };
}
