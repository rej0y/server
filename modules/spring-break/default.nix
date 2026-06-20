{ lib, pkgs, ... }:

let
  paper = {
    version = "26.1.2";
    build = "72";
    sha256 = "0555a0b0468a5198d8fb1a16e1f9e95c81a917a2dc8f2e09867b4044742f6401";
  };

  java = {
    exec = "${pkgs.jdk25}/bin/java";
    args = [
      "-Xms2G"
      "-Xmx16G"
      "-XX:+UseZGC"
      "-XX:+DisableExplicitGC"
    ];
  };
  
  server = {
    dir = "/var/lib/spring-break";
    jar = pkgs.fetchurl {
      name = "paper-${paper.version}-${paper.build}.jar";
      url = "https://fill-data.papermc.io/v1/objects/${paper.sha256}/paper-${paper.version}-${paper.build}.jar";
      curlOptsList = [ "-A" "spring-break-server/1.0 (https://github.com/rej0y/server)" ];
      hash = builtins.convertHash {
        hash = paper.sha256;
        hashAlgo = "sha256";
        toHashFormat = "sri";
      };
    };
  };
in
{
  users.groups.spring-break = {};
  users.users.spring-break = {
    isSystemUser = true;
    group = "spring-break";
    home = server.dir;
  };

  systemd.services.spring-break = {
    description = "Spring Break Minecraft Server";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "spring-break";
      Group = "spring-break";
      StateDirectory = "spring-break";
      WorkingDirectory = server.dir;
      Restart = "on-failure";
      RestartSec = "15s";
      ExecStart = "${java.exec} ${lib.escapeShellArgs (java.args ++ [ "-jar" server.jar "nogui" ])}";
      SuccessExitStatus = "0 143";
    };
  };
}
