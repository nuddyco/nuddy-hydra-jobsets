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
                nixexprinput = "lispnix";
                nixexprpath = "kons-9.nix";
                inputs = {
                  src = githubrepo "nuddyco/nuddy-hydra-jobsets";
                  nixpkgs = githubrepo "NixOS/nixpkgs bcdd40cd4a614fcca4c818fb1da0b068834fea0a";
                  kons-9 = githubrepo "kaveh808/kons-9 main";
                  lispnix = githubrepo "nuddyco/lispnix main";
                };
              } // defaults;
          lisp-packages =
            {
              description = "Common Lisp packages";
              nixexprinput = "lispnix";
              nixexprpath = "sbclPackages.nix";
              inputs = {
                  src = githubrepo "nuddyco/nuddy-hydra-jobsets";
                  nixpkgs = githubrepo "NixOS/nixpkgs release-22.05";
                  lispnix = githubrepo "nuddyco/lispnix main";
              };
            } // defaults;
          }))}
    EOF
    echo
    echo result:
    ${pkgs.jq}/bin/jq < $out
  '';
}
