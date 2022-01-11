with import <nixpkgs> {};
let
    fhs = pkgs.buildFHSUserEnv {
        name = "df-fpga-miner";

        targetPkgs = _: [
            pkgs.bash
            pkgs.gcc
            pkgs.gtkwave
            pkgs.micromamba
        ];

        profile = ''
        set -e
        eval "$(micromamba shell hook -s bash)"
        export MAMBA_ROOT_PREFIX=${builtins.getEnv "PWD"}/.mamba
        micromamba create -q -f environment.yml -c conda-forge
        micromamba activate df-fpga-miner
        set +e
        '';
    };
in fhs.env