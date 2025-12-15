let
  lock = builtins.fromJSON (builtins.readFile ./inputs.lock);
  fetch = name: builtins.fetchTarball lock.${name};
  nixpkgsSrc = fetch "nixpkgs";
  pkgs = import nixpkgsSrc { };
  nixy = import (fetch "nixy");
  nixpkgs = {
    inherit (pkgs) lib;
    legacyPackages.${builtins.currentSystem} = pkgs;
  };

  callFlake =
    src: extraInputs:
    let
      flake = import (src + "/flake.nix");
    in
    flake.outputs ({ self = src; } // extraInputs);
 
  preservationSrc = fetch "preservation";
  diskoSrc = fetch "disko";
  lanzabooteSrc = fetch "lanzaboote";
  appleSiliconSrc = fetch "apple-silicon-support";

  inputs = {
    nixpkgs = nixpkgsSrc;
    preservation = callFlake preservationSrc { };
    disko = callFlake diskoSrc { inherit nixpkgs; };
    lanzaboote = callFlake lanzabooteSrc { inherit nixpkgs; };
    apple-silicon-support = callFlake appleSiliconSrc { inherit nixpkgs; };
  };
in
nixy.mkConfiguration {
  inherit nixpkgs;
  imports = [ ./. ];
  args = {
    inherit inputs;
    resource = ./_resource;
  };
}
