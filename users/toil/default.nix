{ config, lib, pkgs, schematics, ...}: with lib; let
  toil = "toil";
  wsl = config.wsl.enable;
in schematics.forUser toil {
  inherit config;
  withOverrides = {
    home-manager.users.${toil} = {
      presets.user.development.enable = true;

      home.packages = with pkgs; [
        act
      ];

      programs = {
        awscli.enable = true;

        git.userEmail = "prestonvantonder@studyportals.com";
        git.extraConfig.gpg.ssh.program = mkIf wsl "/mnt/c/Users/PrestonvanTonder/AppData/Local/1Password/app/8/op-ssh-sign.exe";
        git.extraConfig.user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTceNH3o6069sOeRT/HmdBctb31UMdJXd1lgSYRytPy";
      };

      xdg.configFile = {
        "Yubico/u2f_keys".source = ./Yubico/u2f_keys;
      };
    };
  };
}
