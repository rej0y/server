{ pkgs, ... }:

{
  paper = {
    version = "26.1.2";
    build = "72";
    sha256 = "0555a0b0468a5198d8fb1a16e1f9e95c81a917a2dc8f2e09867b4044742f6401";
  };

  java = {
    version = pkgs.jdk25;
    args = [
      "-Xmx16G"
      "-XX:+UseZGC"
      "-XX:+DisableExplicitGC"
      "-DGeyser.RakRateLimitingDisabled=true"
    ];
  };

  properties = {
    motd = "Spring Break Minecraft Server";
    server-port = 25566;
    max-players = 50;
    level-name = "world";
    gamemode = "survival";
    difficulty = "hard";
    online-mode = true;
    allow-flight = true;
    simulation-distance = 10;
    view-distance = 10;
    spawn-protection = 0;
    enforce-secure-profile = false;
    white-list = false;
  };

  eula = true;
}
