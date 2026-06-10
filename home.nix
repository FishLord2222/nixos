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
  };

  ##############
  ### KITTY ###
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

  ###############
  ### HYPRLAND ###
  ###############

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      monitor = ",preferred,auto,1.5";

      xwayland = {
        force_zero_scaling = true;
      };

      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$ipc" = "noctalia-shell ipc call";
      "$mainMod" = "ALT";

      env = [
        "TERMINAL,kitty"
        "XCURSOR_THEME,Bibata-Modern-Classic"
        "XCURSOR_SIZE,24"
      ];

      exec-once = [
        "udiskie &"
        "noctalia-shell"
        "systemctl --user enable openrgb"
        "gsettings set org.gnome.desktop.interface cursor-theme \"Bibata-Modern-Classic\""
        "gsettings set org.gnome.desktop.interface cursor-size 24"
      ];

      cursor = {
        no_hardware_cursors = true;
      };

      general = {
        gaps_in = 20;
        gaps_out = 70;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = false;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = false;
        };
      };

      gesture = "3, horizontal, workspace";

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      bind = [
        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, F, fullscreen, 1"

        # Noctalia shell
        "$mainMod, SPACE, exec, $ipc launcher toggle"
        "$mainMod, S, exec, $ipc controlCenter toggle"
        "$mainMod, I, exec, $ipc settings toggle"

        # Focus
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Scratchpad
        "$mainMod, TAB, togglespecialworkspace, magic"
        "$mainMod SHIFT, TAB, movetoworkspace, special:magic"

        # Scroll workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };
}
