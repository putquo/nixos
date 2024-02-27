{ config, lib, pkgs, ... }: {
  options = {
    presets.home.base.enable = lib.mkEnableOption {
      default = false;
      description = "Enable base home preset";
    };
  };

  config = lib.mkIf config.presets.home.base.enable {
    programs = {
      firefox.enable = true;
      fish.enable = true;
      home-manager.enable = true;
    };

    xdg = {
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
        extraConfig = { 
          XDG_PROJECTS_DIR = "$HOME/projects";
        };
      };
    };
  };
}
