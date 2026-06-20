{ lib, pkgs, ... }:

let
  paper = {
    version = "26.1.2";
    build = "72";
    sha256 = "0555a0b0468a5198d8fb1a16e1f9e95c81a917a2dc8f2e09867b4044742f6401";
  };

  java = "${pkgs.jdk25}/bin/java";
  memoryArgs = [ "-Xms2G" "-Xmx16G" ];
  jvmArgs = [
    "-XX:+UseZGC"
    "-XX:+DisableExplicitGC"
  ];

  serverDir = "/var/lib/spring-break";
  serverJar = pkgs.fetchurl {
    name = "paper-${paper.version}-${paper.build}.jar";
    url = "https://fill-data.papermc.io/v1/objects/${paper.sha256}/paper-${paper.version}-${paper.build}.jar";
    curlOptsList = [ "-A" "spring-break-server/1.0 (https://github.com/rej0y/server)" ];
    hash = builtins.convertHash {
      hash = paper.sha256;
      hashAlgo = "sha256";
      toHashFormat = "sri";
    };
  };

  plugins = import ./plugins.nix { inherit pkgs; };
  linkPlugins = map (plugin: "${pkgs.coreutils}/bin/ln -sfn ${plugin.jar} ${serverDir}/plugins/${plugin.fileName}") plugins;
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
      ExecStartPre = [ "${pkgs.coreutils}/bin/mkdir -p ${serverDir}/plugins" ] ++ linkPlugins;
      ExecStart = "${java} ${lib.escapeShellArgs (memoryArgs ++ jvmArgs ++ [ "-jar" serverJar "nogui" ])}";
      SuccessExitStatus = "0 143";
    };
  };
}
