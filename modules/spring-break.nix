{ lib, pkgs, ... }:

let
  serverDir = "/var/lib/spring-break";

  paperVersion = "26.1.2";
  paperBuild = "72";
  paperHash = "0555a0b0468a5198d8fb1a16e1f9e95c81a917a2dc8f2e09867b4044742f6401";

  geyserVersion = "2.10.1";
  geyserBuild = "1172";
  geyserHash = "1a936c7a6a9f8ac241718f5131c81130aa9fd482224706459bf327f9fca39735";

  floodgateVersion = "2.2.5";
  floodgateBuild = "133";
  floodgateHash = "46b4eb2d56bdcf1bc8fa1b3e3b538e3d0d19ccc0ca6fea656993f4c2ed4725c6";

  java = "${pkgs.jdk25}/bin/java";
  memoryArgs = [ "-Xms2G" "-Xmx16G" ];
  jvmArgs = [
    "-XX:+UseZGC"
    "-XX:+DisableExplicitGC"
  ];

  serverJar = pkgs.fetchurl {
    name = "paper-${paperVersion}-${paperBuild}.jar";
    url = "https://fill-data.papermc.io/v1/objects/${paperHash}/paper-${paperVersion}-${paperBuild}.jar";
    hash = builtins.convertHash {
      hash = paperHash;
      hashAlgo = "sha256";
      toHashFormat = "sri";
    };
    curlOptsList = [
      "-A"
      "spring-break-server/1.0 (https://github.com/rej0y/server)"
    ];
  };

  geyserJar = pkgs.fetchurl {
    name = "Geyser-Spigot-${geyserVersion}-${geyserBuild}.jar";
    url = "https://download.geysermc.org/v2/projects/geyser/versions/${geyserVersion}/builds/${geyserBuild}/downloads/spigot";
    hash = builtins.convertHash {
      hash = geyserHash;
      hashAlgo = "sha256";
      toHashFormat = "sri";
    };
  };

  floodgateJar = pkgs.fetchurl {
    name = "floodgate-spigot-${floodgateVersion}-${floodgateBuild}.jar";
    url = "https://download.geysermc.org/v2/projects/floodgate/versions/${floodgateVersion}/builds/${floodgateBuild}/downloads/spigot";
    hash = builtins.convertHash {
      hash = floodgateHash;
      hashAlgo = "sha256";
      toHashFormat = "sri";
    };
  };
in
{
  users.groups.spring-break = {};
  users.users.spring-break = {
    isSystemUser = true;
    group = "spring-break";
    home = serverDir;
  };

  systemd.services.spring-break = {
    description = "Spring Break Minecraft Server";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "spring-break";
      Group = "spring-break";
      StateDirectory = "spring-break";
      WorkingDirectory = serverDir;
      Restart = "on-failure";
      RestartSec = "15s";
      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p ${serverDir}/plugins"
        "${pkgs.coreutils}/bin/ln -sfn ${geyserJar} ${serverDir}/plugins/Geyser-Spigot.jar"
        "${pkgs.coreutils}/bin/ln -sfn ${floodgateJar} ${serverDir}/plugins/floodgate-spigot.jar"
      ];
      ExecStart = "${java} ${lib.escapeShellArgs (memoryArgs ++ jvmArgs ++ [ "-jar" serverJar "nogui" ])}";
      SuccessExitStatus = "0 143";
    };
  };
}
