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

    bazecor =
      let
        inherit (super) appimageTools fetchurl;
        inherit (super.bazecor) meta;
        pname = "bazecor";
        version = "1.3.11";
      in
      (appimageTools.wrapAppImage rec {
        inherit meta pname version;

        src = appimageTools.extract {
          inherit pname version;

          src = fetchurl {
            url = "https://github.com/Dygmalab/Bazecor/releases/download/v${version}/Bazecor-${version}-x64.AppImage";
            hash = "sha256-iMurQDF0CBMnJnjmEgNIKYd8C5B4FguMi4Jqa3dHr3o=";
          };

          # Workaround for https://github.com/Dygmalab/Bazecor/issues/370
          postExtract = ''
            substituteInPlace \
              $out/usr/lib/bazecor/resources/app/.webpack/main/index.js \
              --replace \
                'checkUdev=()=>{try{if(c.default.existsSync(f))return c.default.readFileSync(f,"utf-8").trim()===l.trim()}catch(e){console.error(e)}return!1}' \
                'checkUdev=()=>{return 1}'
          '';
        };

        # also make sure to update the udev rules in ./10-dygma.rules; most recently
        # taken from
        # https://github.com/Dygmalab/Bazecor/blob/v1.3.9/src/main/utils/udev.ts#L6
        extraPkgs = p: (appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ [
          p.glib
        ];

        # Also expose the udev rules here, so it can be used as:
        #   services.udev.packages = [ pkgs.bazecor ];
        # to allow non-root modifications to the keyboards.
        extraInstallCommands = ''
          wrapProgram "$out/bin/${pname}" \
            --set ELECTRON_USE_WAYLAND 1 \
            --add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform --disable-gpu"

          install -m 444 -D ${src}/Bazecor.desktop -t $out/share/applications
          substituteInPlace $out/share/applications/Bazecor.desktop \
            --replace-fail 'Exec=Bazecor' 'Exec=ELECTRON_USE_WAYLAND=1 ${pname}'

          install -m 444 -D ${src}/bazecor.png -t $out/share/pixmaps

          mkdir -p $out/lib/udev/rules.d
          ln -s --target-directory=$out/lib/udev/rules.d ${./10-dygma.rules}
        '';
      }).overrideAttrs { buildInputs = [ super.makeWrapper ]; };

    fprintd = super.fprintd.overrideAttrs (prev: {
      mesonCheckFlags = [
        "--no-suite"
        "fprintd:TestPamFprintd"
      ];
    });

    wbg = super.wbg.override {
      enablePNG = false;
      enableJPEG = false;
      enableWebp = false;
    };

    grimblast = inputs.hyprcontrib.packages.${super.system}.grimblast;
    helix = inputs.helix.packages.${super.system}.default;
    hypridle = inputs.hypridle.packages.${super.system}.default;
    hyprland = inputs.hyprland.packages.${super.system}.default;
    hyprlandPlugins.hyprexpo = inputs.hyprland-plugins.packages.${super.system}.hyprexpo;
    hyprlock = inputs.hyprlock.packages.${super.system}.default;
    wallpaper = "${inputs.self}/assets/bg01.svg";
    xdg-desktop-portal-hyprland = inputs.hyprland.packages.${super.system}.xdg-desktop-portal-hyprland;
    yazi = inputs.yazi.packages.${super.system}.default;
  };
  nur = inputs.nur.overlay;
in
[ custom nur ]
