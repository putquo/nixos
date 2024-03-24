{ lib }: preset: { config, whenEnabled }: {
  options.presets.${preset}.enable = lib.mkEnableOption "Enable ${preset} preset";
  config = lib.mkIf config.presets.${preset}.enable whenEnabled;
}
