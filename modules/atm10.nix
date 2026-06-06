{ config, lib, pkgs, ... }:

let
  atm10Version = "7.0";
  atm10CdnPath = "8094/893";
  atm10FileName = "ServerFiles-${atm10Version}.zip";

  atm10ServerZip = pkgs.fetchurl {
    url = "https://mediafilez.forgecdn.net/files/${atm10CdnPath}/${atm10FileName}";
    hash = "sha256-b3xzqChHx5YcrF2cV5svL096K2RtqA84soyKQG4nn2A=";
  };

  atm10Pack = pkgs.stdenvNoCC.mkDerivation {
    pname = "atm10-server-pack";
    version = atm10Version;
    src = atm10ServerZip;
    nativeBuildInputs = with pkgs; [ unzip ];
    unpackPhase = ''
      mkdir source
      cd source
      unzip -q "$src"
    '';
    installPhase = ''
      mkdir -p $out/share/atm10
      cp -r . $out/share/atm10
    '';
  };
in
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
    wantedBy = [ "multi-user.target" ];

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
      echo "zip: ${atm10ServerZip}"
      echo "pack: ${atm10Pack}"
      ls -la ${atm10Pack}/share/atm10
      java -version
    '';
  };
}
