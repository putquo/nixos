{ lib, ... }: {
  imports = [
    ./presets
  ];

  options.tag = lib.mkOption {
    description = "User tag for additional metadata";
    type = lib.types.str;
  };
}
