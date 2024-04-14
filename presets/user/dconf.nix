{ config, lib, pkgs, ... }: with lib; {
  options = {
    presets.user.dconf.enable = mkEnableOption "the GTK user preset";
  };

  config = mkIf config.presets.user.dconf.enable {
    home.packages = with pkgs; [
      bibata-cursors
      orchis-theme
      tela-icon-theme
    ];

    dconf.enable = true;
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        cursor-theme = "Bibata-Modern-Classic";
        gtk-theme = "Orchis";
        icon-theme = "Tela";
      };
    };
  };
}
