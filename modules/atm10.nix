{ config, lib, pkgs, ... }:

{
  users = {
    users.atm10 = {
      isSystemUser = true;
      group = "atm10";
      home = "/var/lib/atm10";
    };
    groups.atm10 = {};
  };

  systemd.services.atm10 = {
    description = "All The Mods 10 Minecraft Server";

    path = with pkgs; [
      jdk21_headless
    ];

    serviceConfig = {
      User = "atm10";
      Group = "atm10";
      StateDirectory = "atm10";
      WorkingDirectory = "/var/lib/atm10";
    };

    script = ''
      echo "ATM10 service test"
      echo "user: $(id)"
      echo "pwd: $(pwd)"
      java -version
    '';
  };
}
