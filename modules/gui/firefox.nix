{
  mkStr,
  mkBool,
  mkInt,
  mkAttrs,
  mkEnable,
  lib,
  ...
}:
{
  modules.gui = {
    options.firefox = {
      enable = mkEnable "Firefox browser";
      proxy = {
        enable = mkBool false;
        socksProxy = mkStr "127.0.0.1:1080";
        socksVersion = mkInt 5;
        useProxyForDNS = mkBool true;
      };
      dnsOverHTTPS = {
        enable = mkBool true;
        providerURL = mkStr "https://1.1.1.1/dns-query";
      };
      extraPolicies = mkAttrs { };
      extraPreferences = mkAttrs { };
      extraExtensions = mkAttrs { };
    };

    module =
      { node, lib, ... }:
      lib.mkIf (node.gui.enable && node.gui.firefox.enable) {
        programs.firefox = {
          enable = true;
          policies = lib.mkMerge [
            {
              PasswordManagerEnabled = false;
              DisableFirefoxAccounts = true;
              DisablePocket = true;
              EnableTrackingProtection = {
                Value = true;
                Locked = true;
                Cryptomining = true;
                Fingerprinting = true;
              };
              FirefoxHome = {
                Search = true;
                TopSites = false;
                SponsoredTopSites = false;
                Highlights = false;
                Pocket = false;
                SponsoredPocket = false;
                Snippets = false;
                Locked = true;
              };
              FirefoxSuggest = {
                SponsoredSuggestions = false;
                Locked = true;
              };
              Preferences = lib.mkMerge [
                {
                  "browser.urlbar.autoFill.adaptiveHistory.enabled" = true;
                  "browser.tabs.closeWindowWithLastTab" = false;
                  "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
                }
                node.gui.firefox.extraPreferences
              ];
              ExtensionSettings = lib.mkMerge [
                {
                  "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                    installation_mode = "force_installed";
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
                  };
                  "uBlock0@raymondhill.net" = {
                    installation_mode = "force_installed";
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                  };
                  "@testpilot-containers" = {
                    installation_mode = "force_installed";
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
                  };
                }
                node.gui.firefox.extraExtensions
              ];
            }
            (lib.mkIf node.gui.firefox.proxy.enable {
              Proxy = {
                Mode = "manual";
                SOCKSProxy = node.gui.firefox.proxy.socksProxy;
                SOCKSVersion = node.gui.firefox.proxy.socksVersion;
                UseProxyForDNS = node.gui.firefox.proxy.useProxyForDNS;
              };
            })
            (lib.mkIf node.gui.firefox.dnsOverHTTPS.enable {
              DNSOverHTTPS = {
                Enabled = true;
                ProviderURL = node.gui.firefox.dnsOverHTTPS.providerURL;
                Locked = true;
                Fallback = false;
              };
            })
            node.gui.firefox.extraPolicies
          ];
        };
      };
  };
}
