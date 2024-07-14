{ cell, inputs }@_stdArgs: {
  notDetected = { modulesPath, ... }@_nixosModuleArgs: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];
  };
}
