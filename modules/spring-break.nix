{ lib, pkgs, ... }:

let
  serverDir = "/var/lib/spring-break";

  paperVersion = "26.1.2";
  paperBuild = "72";
  paperHash = "0555a0b0468a5198d8fb1a16e1f9e95c81a917a2dc8f2e09867b4044742f6401";

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
      ExecStart = "${java} ${lib.escapeShellArgs (memoryArgs ++ jvmArgs ++ [ "-jar" serverJar "nogui" ])}";
      SuccessExitStatus = "0 143";
    };
  };
}
