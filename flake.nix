# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  description = "Ghaf - Documentation and implementation for TII SSRC Secure Technologies Ghaf Framework";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-new.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-2305.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    jetpack-nixos = {
      url = "github:anduril/jetpack-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jetpack-nixos-new = {
      url = "github:anduril/jetpack-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghaf = {
      url = "github:tiiuae/ghaf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        nixos-generators.follows = "nixos-generators";
        nixos-hardware.follows = "nixos-hardware";
        microvm.follows = "microvm";
        jetpack-nixos.follows = "jetpack-nixos";
      };
    };
    ghaf-newnixos = {
      url = "github:tiiuae/ghaf";
      inputs = {
        nixpkgs.follows = "nixpkgs-new";
        flake-utils.follows = "flake-utils";
        nixos-generators.follows = "nixos-generators";
        nixos-hardware.follows = "nixos-hardware";
        microvm.follows = "microvm";
        jetpack-nixos.follows = "jetpack-nixos";
      };
    };
    ghaf-nixos2305 = {
      url = "github:tiiuae/ghaf";
      inputs = {
        nixpkgs.follows = "nixpkgs-2305";
        flake-utils.follows = "flake-utils";
        nixos-generators.follows = "nixos-generators";
        nixos-hardware.follows = "nixos-hardware";
        microvm.follows = "microvm";
        jetpack-nixos.follows = "jetpack-nixos";
      };
    };
    ghaf-nixos2305-newjetpack = {
      url = "github:tiiuae/ghaf";
      inputs = {
        nixpkgs.follows = "nixpkgs-2305";
        flake-utils.follows = "flake-utils";
        nixos-generators.follows = "nixos-generators";
        nixos-hardware.follows = "nixos-hardware";
        microvm.follows = "microvm";
        jetpack-nixos.follows = "jetpack-nixos-new";
      };
    };
    ghaf-nixos-unstable = {
      url = "github:tiiuae/ghaf";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        flake-utils.follows = "flake-utils";
        nixos-generators.follows = "nixos-generators";
        nixos-hardware.follows = "nixos-hardware";
        microvm.follows = "microvm";
        jetpack-nixos.follows = "jetpack-nixos";
      };
    };
    ghaf-nixos-unstable-newjetpack = {
      url = "github:tiiuae/ghaf";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        flake-utils.follows = "flake-utils";
        nixos-generators.follows = "nixos-generators";
        nixos-hardware.follows = "nixos-hardware";
        microvm.follows = "microvm";
        jetpack-nixos.follows = "jetpack-nixos-new";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-new,
    nixpkgs-2305,
    nixpkgs-unstable,
    flake-utils,
    nixos-generators,
    nixos-hardware,
    microvm,
    jetpack-nixos,
    jetpack-nixos-new,
    ghaf,
    ghaf-newnixos,
    ghaf-nixos2305,
    ghaf-nixos2305-newjetpack,
    ghaf-nixos-unstable,
    ghaf-nixos-unstable-newjetpack,
  }: let
    systems = with flake-utils.lib.system; [
      x86_64-linux
      aarch64-linux
    ];
  in
    # Combine list of attribute sets together
    nixpkgs.lib.foldr nixpkgs.lib.recursiveUpdate {} [
      # Documentation
      (flake-utils.lib.eachSystem systems (system: {
        formatter = nixpkgs.legacyPackages.${system}.alejandra;
      }))

      # Hydra jobs
      (import ./hydrajobs.nix {inherit nixpkgs ghaf;})

      # New stable NixOS
      {
        hydraJobs = (
          nixpkgs.lib.mapAttrs' (name: value: nixpkgs.lib.nameValuePair ("newnixos-" + name) value)
          (import ./hydrajobs.nix {
            ghaf = ghaf-newnixos;
            inherit nixpkgs;
          })
          .hydraJobs
        );
      }

      # NixOS 23.05
      {
        hydraJobs = (
          nixpkgs.lib.mapAttrs' (name: value: nixpkgs.lib.nameValuePair ("nixos2305-" + name) value)
          (import ./hydrajobs.nix {
            ghaf = ghaf-nixos2305;
            inherit nixpkgs;
          })
          .hydraJobs
        );
      }

      # NixOS 23.05 + New Jetpack NixOS
      {
        hydraJobs = (
          nixpkgs.lib.mapAttrs' (name: value: nixpkgs.lib.nameValuePair ("nixos2305-newjp-" + name) value)
          (import ./hydrajobs.nix {
            ghaf = ghaf-nixos2305-newjetpack;
            inherit nixpkgs;
          })
          .hydraJobs
        );
      }

      # NixOS Unstable
      {
        hydraJobs = (
          nixpkgs.lib.mapAttrs' (name: value: nixpkgs.lib.nameValuePair ("nixos-unstable-" + name) value)
          (import ./hydrajobs.nix {
            ghaf = ghaf-nixos-unstable;
            inherit nixpkgs;
          })
          .hydraJobs
        );
      }

      # NixOS Unstable + New Jetpack NixOS
      {
        hydraJobs = (
          nixpkgs.lib.mapAttrs' (name: value: nixpkgs.lib.nameValuePair ("unstable-newjp-" + name) value)
          (import ./hydrajobs.nix {
            ghaf = ghaf-nixos-unstable-newjetpack;
            inherit nixpkgs;
          })
          .hydraJobs
        );
      }
    ];
}
