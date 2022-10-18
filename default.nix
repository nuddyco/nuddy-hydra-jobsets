{ nixpkgs ? <nixpkgs>
, declInput ? {}
}:
let pkgs = import nixpkgs {};
    defaults = { enabled = 1;
                 hidden = false;
                 checkinterval = 300;
                 schedulingshares = 10;
                 enableemail = false;
                 emailoverride = "";
                 keepnr = 100;
               };
in
{
  jobsets = pkgs.runCommand "spec.json" {} ''
    cat <<EOF
    ${builtins.toXML declInput}
    EOF
    cat > $out <<EOF
    ${builtins.toJSON
      ({ description = "kons-9 master";
         nixexprinput = "src";
         nixexprpath = "release.nix";
         inputs = {
           src = {
             type = "git";
             value = "https://github.com/nuddyco/nuddy-hydra-jobsets";
             emailresponsible = false;
           };
           nixpkgs = {
             type = "git";
             value = "https://github.com/NixOS/nixpkgs release-22.05";
             emailresponsible = false;
           };
         };
       } // defaults)}
    EOF
  '';
}
