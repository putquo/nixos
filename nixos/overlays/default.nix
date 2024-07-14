{ inputs }:
let
  custom = _self: super: {
    _1password-gui = super._1password-gui.overrideAttrs (prev: {
      postInstall = (prev.postInstall or "") + ''
        mkdir -p $out/etc/xdg/autostart
        cp $out/share/applications/${prev.pname}.desktop $out/etc/xdg/autostart/${prev.pname}.desktop
        substituteInPlace $out/etc/xdg/autostart/${prev.pname}.desktop \
          --replace 'Exec=${prev.pname} %U' 'Exec=${prev.pname} --silent %U'
      '';
    });

    anyrun = inputs.anyrun.packages.${super.system}.anyrun-with-all-plugins;

    fprintd = super.fprintd.overrideAttrs (prev: {
      mesonCheckFlags = [
        "--no-suite"
        "fprintd:TestPamFprintd"
      ];
    });

    grimblast = inputs.hyprcontrib.packages.${super.system}.grimblast;
    helix = inputs.helix.packages.${super.system}.default;
    hypridle = inputs.hypridle.packages.${super.system}.default;
    hyprland = inputs.hyprland.packages.${super.system}.default;
    hyprlandPlugins.hyprexpo = inputs.hyprland-plugins.packages.${super.system}.hyprexpo;
    hyprlock = inputs.hyprlock.packages.${super.system}.default;
    wallpaper = "${inputs.self}/assets/bg01.svg";

    wbg = super.wbg.override {
      enablePNG = false;
      enableJPEG = false;
      enableWebp = false;
    };

    xdg-desktop-portal-hyprland = inputs.hyprland.packages.${super.system}.xdg-desktop-portal-hyprland;
    yazi = inputs.yazi.packages.${super.system}.default;
  };
  nur = inputs.nur.overlay;
in
[ custom nur ]
