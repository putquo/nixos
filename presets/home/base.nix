{ config, lib, osConfig, pkgs, ... }: {
  options = {
    presets.home.base.enable = lib.mkEnableOption {
      default = false;
      description = "Enable base home preset";
    };
  };

  config = lib.mkIf config.presets.home.base.enable {
    home.stateVersion = osConfig.system.stateVersion;

    programs = {
      firefox.enable = true;

      fish.enable = true;
      fish.interactiveShellInit = ''
        set fish_greeting
        fish_vi_key_bindings
      '';

      home-manager.enable = true;
    };

    xdg = {
      configFile."Yubico/u2f_keys".text =
        "justin:J10bEUa4W6n6a3EidpTZ3ip0ee48tbyY/0Fuu02W2NwPGzGtCn2UxjsGXYciNO3otL+YVu04cUfVP7iDbdwj1w=="
        + ",G285zaLYdUFaTMg2WlhWvSeRkV39fG3p6jFEjK8AEAvyQViziFCuUE31fdSCPT2P8vKx8fcaPEHuXTGMeIzCMA=="
        + ",es256,+presence";
      
      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = "$HOME/desktop";
        documents = "$HOME/documents";
        download = "$HOME/downloads";
        music = "$HOME/media/music";
        pictures = "$HOME/media/images";
        publicShare = "$HOME/public";
        videos = "$HOME/media/videos";
        templates = "$HOME/templates";
      };
    };
  };
}
