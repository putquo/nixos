{ config, lib, lib', osConfig, pkgs, ... }: with lib'; templated.preset "desktop" {
  inherit config;
  whenEnabled = {
    home.stateVersion = osConfig.system.stateVersion;

    programs.firefox.enable = true;

    programs.fish.enable = true;
    programs.fish.interactiveShellInit = ''
      set fish_greeting
      fish_vi_key_bindings
    '';

    programs.foot.enable = true;
    programs.foot.settings = {
      main = {
        font = "MonaspiceNe Nerd Font Mono:size=11";
        initial-window-size-pixels = "1200x700";
        pad = "8x4";
      };        
    };

    programs.home-manager.enable = true;

    xdg.configFile."1Password/ssh/agent.toml".text = ''
      [[ssh-keys]]
      vault = "${config.tag}"
    '';

    xdg.configFile."Yubico/u2f_keys".text =
        "justin:J10bEUa4W6n6a3EidpTZ3ip0ee48tbyY/0Fuu02W2NwPGzGtCn2UxjsGXYciNO3otL+YVu04cUfVP7iDbdwj1w=="
        + ",G285zaLYdUFaTMg2WlhWvSeRkV39fG3p6jFEjK8AEAvyQViziFCuUE31fdSCPT2P8vKx8fcaPEHuXTGMeIzCMA=="
        + ",es256,+presence";

    xdg.desktopEntries = lib.mkIf (osConfig.presets.gaming.enable && !config.presets.gaming.enable) {
      steam.exec = "";
      steam.name = "Steam";
      steam.noDisplay = true;
    };

    xdg.userDirs.enable = true;
    xdg.userDirs.createDirectories = true;
    xdg.userDirs.desktop = "$HOME/desktop";
    xdg.userDirs.documents = "$HOME/documents";
    xdg.userDirs.download = "$HOME/downloads";
    xdg.userDirs.music = "$HOME/media/music";
    xdg.userDirs.pictures = "$HOME/media/images";
    xdg.userDirs.publicShare = "$HOME/public";
    xdg.userDirs.videos = "$HOME/media/videos";
    xdg.userDirs.templates = "$HOME/templates";
  };
}
