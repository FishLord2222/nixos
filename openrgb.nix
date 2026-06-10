 
{ config, pkgs, ... }:
{

   # RGB / Hardware control / Load OpenRGB profile on login
   hardware.i2c.enable = true;   # required for ddcutil
  services.udev.packages    = [ pkgs.openrgb ];
  systemd.user.services.openrgb = {
    description = "OpenRGB";
    wantedBy    = [ "default.target" ];
    after       = [ "graphical-session.target" ];
    serviceConfig = {
      Type          = "oneshot";
      ExecStartPre  = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart     = "${pkgs.openrgb}/bin/openrgb --profile Blue";
    };
  };
  environment.systemPackages = with pkgs; [
  openrgb
];
}
