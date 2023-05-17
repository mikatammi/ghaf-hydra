# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{ghaf}: {
  hydraJobs = {
    intel-nuc-debug.x86_64-linux = ghaf.packages.x86_64-linux.intel-nuc-debug;
    nvidia-jetson-orin-debug.aarch64-linux = ghaf.packages.aarch64-linux.nvidia-jetson-orin-debug;
  };
}
