# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  nixpkgs,
  ghaf,
}: let
  lib = nixpkgs.lib;
in {
  hydraJobs = lib.foldr lib.recursiveUpdate {} (
    lib.mapAttrsToList (architecture: value: (
      lib.concatMapAttrs (pname: package: {${pname} = {${architecture} = package;};}) value
    ))
    ghaf.packages
  );
}
