{ lib, pkgs, ... }:

let
  serverDir = "/var/lib/spring-break";

  paperVersion = "26.1.2";
  paperBuild = "70";
  paperHash = "6c59eefe2752f97ee79f83ad0a61fe14865a0976e4ac06597f53de6c44afd6c5";

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
