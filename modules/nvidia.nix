# nvidia.nix — Nvidia-specific configuration.
# Import this module only on systems that have an Nvidia GPU.
#
# In flake.nix, add it to the relevant nixosConfiguration's modules list:
#
#   modules = [
#     ./configuration.nix
#     ./nvidia.nix      # ← include only on Nvidia systems
#   ];

{ config, pkgs, ... }:

{
  ###############
  # Kernel      #
  ###############
  boot.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
    "i2c-dev"   # already enabled by hardware.i2c, kept for explicitness
    "coretemp"
  ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  ##################
  # Nvidia driver  #
  ##################
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable       = true;
    open                     = false;   # use proprietary kernel module
    nvidiaSettings           = true;
    package                  = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable   = true;
  };

  hardware.graphics = {
    enable      = true;
    enable32Bit = true;   # needed for Steam / 32-bit games
  };

  ##################################
  # Nvidia-specific session variables
  # (general Wayland vars live in configuration.nix)
  ##################################
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME        = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS  = "1";
  };
  environment.systemPackages = with pkgs; [
  nvtopPackages.nvidia
  ];
}
