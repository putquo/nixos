{ inputs, context, overlays, ... }: inputs.nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";
  modules = [
    context
    inputs.home-manager.nixosModules.home-manager
    ../../modules/shared
    ../../options
    ({ config, pkgs, ... }: {
      imports = [ ./hardware.nix ./home.nix ];

      nixpkgs.overlays = overlays;

      # Bootloader.
      boot.loader.systemd-boot.configurationLimit = 5;
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = "titan"; # Define your hostname.
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Enable networking
      networking.networkmanager.enable = true;

      # Set your time zone.
      time.timeZone = "Europe/Amsterdam";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "nl_NL.UTF-8";
        LC_IDENTIFICATION = "nl_NL.UTF-8";
        LC_MEASUREMENT = "nl_NL.UTF-8";
        LC_MONETARY = "nl_NL.UTF-8";
        LC_NAME = "nl_NL.UTF-8";
        LC_NUMERIC = "nl_NL.UTF-8";
        LC_PAPER = "nl_NL.UTF-8";
        LC_TELEPHONE = "nl_NL.UTF-8";
        LC_TIME = "nl_NL.UTF-8";
      };

      # Enable the X11 windowing system.
      services.xserver.enable = true;

      # Enable the GNOME Desktop Environment.
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.desktopManager.gnome.enable = true;

      # Configure Nvidia
      # Enable OpenGL      
      hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
      # Load Nvidia driver for Xorg and Wayland
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        # Modesetting is required
        modesetting.enable = true;

        # Nvidia power management
        # Experimental and can cause sleep/suspend to fail
        powerManagement.enable = false;
        # Nvidia fine-grained power management
        # Turns off GPU when not in use
        # Experimental and only works with modern Nvidia GPUs (Turing and later)
        powerManagement.finegrained = false;

        # Nvidia open soure kernel module (not to be confused with the independent third-party "nouveau" open source driver)
        # Support is limited to the Turing and later architectures
        # Full list of supported architectures available at: https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
        # Only available from driver 515.43.04+
        # Currently in alpha/buggy, so false is the recommended setting
        open = false;

        # Enable the Nvidia settings menu
        # Accessible via "nvidia-settings"
        nvidiaSettings = true;

        # The driver version
        # Dependent on your GPU
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };

      # Configure keymap in X11
      services.xserver = {
        layout = "us";
        xkbVariant = "";
      };

      # Enable CUPS to print documents.
      services.printing.enable = true;

      # Enable sound with pipewire.
      sound.enable = true;
      hardware.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
      };

      # Enable touchpad support (enabled default in most desktopManager).
      # services.xserver.libinput.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.${config.user.name} = {
        isNormalUser = true;
        description = config.user.description;
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [
          firefox
        ];
      };

      # Enable automatic login for the user
      services.xserver.displayManager.autoLogin.enable = true;
      services.xserver.displayManager.autoLogin.user = config.user.name;

      # Work around for automatic login with GNOME
      systemd.services."getty@tty1".enable = false;
      systemd.services."autovt@tty1".enable = false;

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        curl
        git
        vim
        wget
      ];

      environment.variables.EDITOR = "vim";

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;
      # programs.gnupg.agent = {
      #   enable = true;
      #   enableSSHSupport = true;
      # };

      # List services that you want to enable:

      # Enable the OpenSSH daemon.
      # services.openssh.enable = true;

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "23.11"; # Did you read the comment?
    })
  ];
}
