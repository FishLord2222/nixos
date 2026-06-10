{ config, pkgs, inputs, ... }:

{
  home.username = "enzo";
  home.homeDirectory = "/home/enzo";
  home.stateVersion = "26.05";

  home.packages = [];

  home.file = {};

  home.sessionVariables = {
    GDK_BACKEND = "wayland";
  };

  programs.home-manager.enable = true;

  #############
  ### SHELL ###
  #############

  programs.zsh = {
    enable = true;
    history = {
      path = "${config.home.homeDirectory}/.histfile";
      size = 3000;
      save = 1000;
    };
    initContent = ''
      fastfetch
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    presets = [ "gruvbox-rainbow" ];
  };

  ##############
  ### KITTY  ###
  ##############

  programs.kitty = {
    enable = true;
    font = {
      name = "Hack Nerd Font";
      size = 12.0;
    };
    settings = {
      cursor_trail = 2;
      disable_ligatures = "never";
      confirm_os_window_close = 0;
      background_opacity = "0.8";
    };
    # Theme managed by noctalia via current-theme.conf
    extraConfig = ''
      include current-theme.conf
    '';
  };

 }
