#!/usr/bin/env nu
def main [
    --repo-root: string
    --alejandra-bin: string
    --nufmt-bin: string
    --nufmt-config: string
] {
    let nix_fmt = (^$alejandra_bin --check $repo_root | complete)
    if $nix_fmt.exit_code != 0 { error make {msg: "Alejandra formatting check failed"} }
    let nu_files = (glob $"($repo_root)/**/*.nu")
    if (($nu_files | length) > 0) {
        let nu_fmt = (^$nufmt_bin --config $nufmt_config --dry-run ...$nu_files | complete)
        if $nu_fmt.exit_code != 0 { error make {msg: "nufmt formatting check failed"} }
    }
}
