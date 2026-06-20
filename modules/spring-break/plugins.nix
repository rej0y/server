{ pkgs }:

let
  geyserVersion = "2.10.1";
  geyserBuild = "1172";
  geyserHash = "1a936c7a6a9f8ac241718f5131c81130aa9fd482224706459bf327f9fca39735";

  floodgateVersion = "2.2.5";
  floodgateBuild = "133";
  floodgateHash = "46b4eb2d56bdcf1bc8fa1b3e3b538e3d0d19ccc0ca6fea656993f4c2ed4725c6";
in
[
  {
    fileName = "Geyser-Spigot.jar";
    jar = pkgs.fetchurl {
      name = "Geyser-Spigot-${geyserVersion}-${geyserBuild}.jar";
      url = "https://download.geysermc.org/v2/projects/geyser/versions/${geyserVersion}/builds/${geyserBuild}/downloads/spigot";
      hash = builtins.convertHash {
        hash = geyserHash;
        hashAlgo = "sha256";
        toHashFormat = "sri";
      };
    };
  }

  {
    fileName = "floodgate-spigot.jar";
    jar = pkgs.fetchurl {
      name = "floodgate-spigot-${floodgateVersion}-${floodgateBuild}.jar";
      url = "https://download.geysermc.org/v2/projects/floodgate/versions/${floodgateVersion}/builds/${floodgateBuild}/downloads/spigot";
      hash = builtins.convertHash {
        hash = floodgateHash;
        hashAlgo = "sha256";
        toHashFormat = "sri";
      };
    };
  }
]
