# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  nixpkgs,
  ghaf,
}: let
  lib = nixpkgs.lib;
in {
  hydraJobs = lib.foldr lib.recursiveUpdate {} (
    lib.mapAttrsToList (architecture1: value: let
      architecture =
        if architecture1 == "riscv64-linux"
        then "x86_64-linux"
        else architecture1;
    in (
      lib.concatMapAttrs (pname: package: {
        "${lib.optionalString (architecture1 == "riscv64-linux") (architecture1 + "-")}${pname}" = {
          ${architecture} = package // {meta.timeout = 50 * 60 * 60;};
        };
      })
      value
    ))
    ghaf.packages
  );
}
