{
  description = "reusable flake module for Nix users who want to optimize Neovim startup performance";

  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ flake-parts-lib, ... }:
      let inherit (flake-parts-lib) importApply;
      in {
        systems = import inputs.systems;
        perSystem = { self', pkgs, system, ... }: {
          _module.args.pkgs = import inputs.nixpkgs { inherit system; };
        };
        flake.flakeModule = importApply ./flake-module.nix { };
      });
}
