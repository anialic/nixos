{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixy.url = "github:anialic/nixy";
    preservation.url = "github:nix-community/preservation";
    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    apple-silicon-support.url = "github:nix-community/nixos-apple-silicon";
  };

  outputs =
    { nixpkgs, nixy, ... }@inputs:
    nixy.mkFlake {
      inherit nixpkgs;
      imports = [
        ./modules
        ./nodes
      ];
      args = {
        inherit inputs;
        resource = ./_resource;
      };
    };
}
