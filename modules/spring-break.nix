{ lib, pkgs, ... }:

let
  serverDir = "/var/lib/spring-break";
  paperVersion = "26.1.2";
  serverJar = "${serverDir}/paper-${paperVersion}.jar";

  java = "${pkgs.jdk25}/bin/java";
  memoryArgs = [ "-Xms2G" "-Xmx16G" ];
  jvmArgs = [
    "-XX:+UseZGC"
    "-XX:+ZGenerational"
    "-XX:+DisableExplicitGC"
  ];
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
