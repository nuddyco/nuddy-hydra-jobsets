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
    declInput:
    ${builtins.toXML declInput}
    EOF
    cat > $out <<EOF
    ${builtins.toJSON
      (let githubrepo = id: { type = "git";
                              value = "https://github.com/${id}";
                              emailresponsible = false; };
       in
         ({ main =
              { description = "kons-9 master";
                nixexprinput = "kons-9";
                nixexprpath = "kons-9.nix";
                inputs = {
                  src = githubrepo "nuddyco/nuddy-hydra-jobsets";
                  nixpkgs = githubrepo "NixOS/nixpkgs release-22.05";
                  kons-9 = githubrepo "kaveh808/kons-9";
                  lispnix = githubrepo "nuddyco/lispnix";
                };
              } // defaults; }))}
    EOF
    echo
    echo result:
    ${pkgs.jq}/bin/jq < $out
  '';
}
