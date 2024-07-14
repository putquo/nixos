{ cell, inputs }@_stdArgs: {
  "x86_64-linux" = {
    nixpkgs.localSystem.system = "x86_64-linux";
  };
}
