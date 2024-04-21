{ inputs }:
let
  libs = [
    "bootstrap"
    "templated"
    "theme"
  ];
  _self = with inputs.nixpkgs.lib; genAttrs libs
    (lib: import ./${lib} { inherit inputs; lib' = _self; });
in
_self
