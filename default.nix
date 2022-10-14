{ nixpkgs, declInput }: let pkgs = import nixpkgs {}; in {
  jobsets = pkgs.runCommand "spec.json" {} ''
    cat <<EOF
    ${builtins.toJSON declInput}
    EOF
    cat > $out <<EOF
    {
        "master": {
            "enabled": 1,
            "hidden": false,
            "description": "js",
            "nixexprinput": "src",
            "nixexprpath": "release.nix",
            "checkinterval": 300,
            "schedulingshares": 100,
            "enableemail": false,
            "emailoverride": "",
            "keepnr": 3,
            "inputs": {
                "src": { "type": "git", "value": "git://github.com/nuddyco/nuddy-hydra-jobsets.git", "emailresponsible": false },
                "nixpkgs": { "type": "git", "value": "git://github.com/NixOS/nixpkgs.git release-20.05", "emailresponsible": false }
            }
        }
    }

    EOF
  '';
}
