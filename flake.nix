# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  description = "Ghaf - Documentation and implementation for TII SSRC Secure Technologies Ghaf Framework";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-new.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils-new.url = "github:numtide/flake-utils";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators-new = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-new";
    };
    nixos-generators-unstable = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-hardware-new.url = "github:nixos/nixos-hardware";
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    microvm-new = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs-new";
      inputs.flake-utils.follows = "flake-utils-new";
    };
    microvm-unstable = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.flake-utils.follows = "flake-utils-new";
    };
    jetpack-nixos = {
      url = "github:anduril/jetpack-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jetpack-nixos-new = {
      url = "github:anduril/jetpack-nixos";
      inputs.nixpkgs.follows = "nixpkgs-new";
    };
    jetpack-nixos-unstable = {
      url = "github:anduril/jetpack-nixos";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
    ghaf-newnixos-newjetpack = {
      url = "github:tiiuae/ghaf";
      inputs = {
        nixpkgs.follows = "nixpkgs-new";
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
    ghaf-allnew = {
      url = "github:tiiuae/ghaf";
      inputs = {
        nixpkgs.follows = "nixpkgs-new";
        flake-utils.follows = "flake-utils-new";
        nixos-generators.follows = "nixos-generators-new";
        nixos-hardware.follows = "nixos-hardware-new";
        microvm.follows = "microvm-new";
        jetpack-nixos.follows = "jetpack-nixos-new";
      };
    };
    ghaf-allunstable = {
      url = "github:tiiuae/ghaf";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        flake-utils.follows = "flake-utils-new";
        nixos-generators.follows = "nixos-generators-unstable";
        nixos-hardware.follows = "nixos-hardware-new";
        microvm.follows = "microvm-unstable";
        jetpack-nixos.follows = "jetpack-nixos-unstable";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-new,
    nixpkgs-unstable,
    flake-utils,
    flake-utils-new,
    nixos-generators,
    nixos-generators-new,
    nixos-generators-unstable,
    nixos-hardware,
    nixos-hardware-new,
    microvm,
    microvm-new,
    microvm-unstable,
    jetpack-nixos,
    jetpack-nixos-new,
    jetpack-nixos-unstable,
    ghaf,
    ghaf-newnixos,
    ghaf-newnixos-newjetpack,
    ghaf-nixos-unstable,
    ghaf-nixos-unstable-newjetpack,
    ghaf-allnew,
    ghaf-allunstable,
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

      # New stable NixOS + New Jetpack NixOS
      {
        hydraJobs = (
          nixpkgs.lib.mapAttrs' (name: value: nixpkgs.lib.nameValuePair ("newnixos-newjp-" + name) value)
          (import ./hydrajobs.nix {
            ghaf = ghaf-newnixos-newjetpack;
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

      # All New
      {
        hydraJobs = (
          nixpkgs.lib.mapAttrs' (name: value: nixpkgs.lib.nameValuePair ("allnew-" + name) value)
          (import ./hydrajobs.nix {
            ghaf = ghaf-allnew;
            inherit nixpkgs;
          })
          .hydraJobs
        );
      }

      # NixOS Unstable + All New
      {
        hydraJobs = (
          nixpkgs.lib.mapAttrs' (name: value: nixpkgs.lib.nameValuePair ("allunstable-" + name) value)
          (import ./hydrajobs.nix {
            ghaf = ghaf-allunstable;
            inherit nixpkgs;
          })
          .hydraJobs
        );
      }
    ];
}
