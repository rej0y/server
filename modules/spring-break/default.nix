{ lib, pkgs, ... }:

let
  settings = import ./settings.nix { inherit pkgs; };
  plugins = import ./plugins.nix { inherit pkgs; };

  server = {
    dir = "/var/lib/spring-break";
    jar = pkgs.fetchurl {
      name = "paper-${settings.paper.version}-${settings.paper.build}.jar";
      url = "https://fill-data.papermc.io/v1/objects/${settings.paper.sha256}/paper-${settings.paper.version}-${settings.paper.build}.jar";
      curlOptsList = [ "-A" "spring-break-server/1.0 (https://github.com/rej0y/server)" ];
      hash = builtins.convertHash {
        hash = settings.paper.sha256;
        hashAlgo = "sha256";
        toHashFormat = "sri";
      };
    };
    init = pkgs.writeShellScript "server-init" ''
      set -eu

      ${pkgs.coreutils}/bin/install -Dm0644 ${
        pkgs.writeText "server.properties" (lib.generators.toKeyValue {} settings.properties)
      } ${server.dir}/server.properties

      ${pkgs.coreutils}/bin/install -Dm0644 ${
        pkgs.writeText "eula.txt" "eula=${lib.boolToString settings.eula}\n"
      } ${server.dir}/eula.txt

      ${pkgs.coreutils}/bin/mkdir -p ${server.dir}/plugins

      ${pkgs.findutils}/bin/find ${server.dir}/plugins -maxdepth 1 -type l -name '*.jar' -delete

      ${lib.concatMapStringsSep "\n" (
        plugin: ''${pkgs.coreutils}/bin/ln -sfT ${plugin.jar} ${server.dir}/plugins/${plugin.fileName}''
      ) plugins}
    '';
  };
in
{
  users = {
    groups.spring-break = {};
    users.spring-break = {
      isSystemUser = true;
      group = "spring-break";
      home = server.dir;
    };
  };

  systemd.services.spring-break = {
    description = "Spring Break Minecraft Server";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "spring-break";
      Group = "spring-break";
      StateDirectory = "spring-break";
      StateDirectoryMode = "0700";
      UMask = "0077";
      WorkingDirectory = server.dir;
      Restart = "on-failure";
      RestartSec = "15s";
      ExecStartPre = server.init;
      ExecStart = "${settings.java.version}/bin/java ${lib.escapeShellArgs (settings.java.args ++ [ "-jar" server.jar "nogui" ])}";
      SuccessExitStatus = "0 143";
    };
  };
}
