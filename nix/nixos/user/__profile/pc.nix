{ ... }@_haumeaArgs:
{ config, lib, osConfig, pkgs, ... }@_hmModuleArgs: {
  home.stateVersion = osConfig.system.stateVersion;

  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    window.decorations = "None";
    window.dynamic_padding = true;
    window.padding.x = 8;
  };

  programs.btop.enable = true;

  programs.firefox.enable = true;
  programs.firefox.package = pkgs.firefox-bin;
  programs.firefox.profiles.default = {
    id = 0;
    name = "default";
    isDefault = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      onepassword-password-manager
      ublock-origin
    ];
  };

  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    set fish_greeting
    fish_vi_key_bindings
  '';

  programs.home-manager.enable = true;

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
}
