{ pkgs, ... }:

{
  paper = {
    version = "26.1.2";
    build = "74";
    sha256 = "1d70b1dab9cf4a6de615209a536f3a45a2186240253c428213ce2188ab95e5f7";
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
