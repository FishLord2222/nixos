# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  ##############
  # Bootloader #
  ##############
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable       = true;
    device       = "nodev";
    efiSupport   = true;
    useOSProber  = true;
    gfxmodeEfi   = "1024x768";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  ################
  # Localisation #
  ################
  networking.hostName = "walterwhite";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT    = "en_US.UTF-8";
    LC_MONETARY       = "en_US.UTF-8";
    LC_NAME           = "en_US.UTF-8";
    LC_NUMERIC        = "en_US.UTF-8";
    LC_PAPER          = "en_US.UTF-8";
    LC_TELEPHONE      = "en_US.UTF-8";
    LC_TIME           = "en_US.UTF-8";
  };

  services.xserver.xkb = {
    layout  = "us";
    variant = "";
  };

  ######################
  # Display / Greeter  #
  ######################
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation      = "matrix";
      bigclock       = true;
      bigclock_12hr  = true;
    };
  };

  ##########
  # Audio  #
  ##########
  security.rtkit.enable = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
  };

  ###############
  # Bluetooth   #
  ###############
  hardware.bluetooth = {
    enable       = true;
    powerOnBoot  = true;
  };
  services.blueman.enable = true;

  ##########
  # Wayland / Desktop #
  ##########
  programs.hyprland.enable = true;

  xdg.portal = {
    enable        = true;
    extraPortals  = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };

  environment.variables = {
    TERMINAL     = "kitty";
    FILE_MANAGER = "thunar";
  };

  # Wayland / Qt / GTK session variables (non-Nvidia ones live here;
  # Nvidia-specific vars are in nvidia.nix)
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_QPA_PLATFORM      = "wayland";
    GDK_BACKEND          = "wayland,x11";
    SDL_VIDEODRIVER      = "wayland";
    CLUTTER_BACKEND      = "wayland";
    NIXOS_OZONE_WL       = "1";
  };

  xdg.mime.defaultApplications = {
    "inode/directory" = "thunar.desktop";
  };

  ##########
  # Shell  #
  ##########
  programs.zsh = {
    enable                  = true;
    autosuggestions.enable  = true;
    syntaxHighlighting.enable = true;
  };

  #################
  # User account  #
  #################
  users.users.enzo = {
    isNormalUser  = true;
    description   = "enzo";
    extraGroups   = [ "networkmanager" "wheel" ];
    packages      = with pkgs; [];
    shell         = pkgs.zsh;
  };
  # GIT
  programs.git = {
  enable = true;
  config = {
    user.name = "FishLord2222";
    user.email = "monteleoneenzo936@gmail.com";
  };
};
# home-manager
   home-manager = {
  # also pass inputs to home-manager modules
  extraSpecialArgs = {inherit inputs;};
  users = {
    "enzo" = import ./home.nix;
  };
};
  ###########
  # Gaming  #
  ###########
  programs.steam = {
    enable                        = true;
    gamescopeSession.enable       = true;
    remotePlay.openFirewall       = true;
    dedicatedServer.openFirewall  = true;
  };
  programs.gamemode.enable = true;

  services.udev.extraRules  = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666", GROUP="plugdev"
  '';

  ###############
  # Misc services #
  ###############
  services.openssh.enable                = true;
  services.flatpak.enable                = true;
  services.udisks2.enable                = true;
  services.power-profiles-daemon.enable  = true;
  services.printing.enable = true;
  programs.kdeconnect.enable = true;

  # nix-ld: run unpatched binaries (Steam controller, etc.)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libusb1
    hidapi
    stdenv.cc.cc.lib
  ];
  #######################
  # System fonts        #
  #######################
  fonts.packages = with pkgs; [
  nerd-fonts.hack
  ];
  #######################
  # System packages     #
  #######################
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [

    # ── Noctalia shell ────────────────────────────────────────────────
    noctalia-shell
    noctalia-qs
    # ── Browsers ──────────────────────────────────────────────────────
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    firefox

    # ── Terminal emulators ────────────────────────────────────────────
    kitty
    foot

    # ── Shell tools ───────────────────────────────────────────────────
    starship
    fzf
    fastfetch
    btop
    htop
    neovim
    lynx

    # ── File management ───────────────────────────────────────────────
    thunar
    tumbler             # thumbnail service for Thunar
    ffmpegthumbnailer   # video thumbnails
    xarchiver
    udiskie
    udisks2
    gparted
    filezilla
    kdePackages.dolphin
    kdePackages.ark

    # ── Media ─────────────────────────────────────────────────────────
    vlc
    mpv
    image-roll
    obs-studio
    feishin
    cava
    guvcview

    # ── Internet / Communication ──────────────────────────────────────
    vesktop
    discord
    qbittorrent
    proton-vpn

    # ── Gaming ────────────────────────────────────────────────────────
    protonup-qt
    mangohud
    prismlauncher
    unigine-superposition

    # ── Productivity ──────────────────────────────────────────────────
    libreoffice
    mission-center

    # ── System utilities ──────────────────────────────────────────────
    ddcutil         # external monitor brightness
    lm_sensors
    popsicle        # USB flasher
    pavucontrol
    flatpak
    ntfs3g

    # ── Hyprland tools ────────────────────────────────────────────────
    hyprshot
    hyprlock

    # ── Screenshot / screen-capture pipeline ─────────────────────────
    grim
    slurp
    wl-clipboard
    wl-screenrec
    tesseract
    imagemagick
    zbar

    # ── Wayland / Qt / GTK runtime libs ──────────────────────────────
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    qgnomeplatform-qt6

    # ── Theming / Customisation ───────────────────────────────────────
    papirus-icon-theme
    bibata-cursors
    nwg-look

    # ── Development / build tools ─────────────────────────────────────
    gcc
    gnumake
    cmake
    pkg-config
    binutils
    autoconf
    automake
    libtool
    git
    wget
    curl
    ffmpeg
    jq

    # ── Fun / misc ────────────────────────────────────────────────────
    cmatrix
    cowsay

  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = "26.05"; # Did you read the comment?
}
