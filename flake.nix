{
  description = "vxvicfg Shell Ultimate - Quickshell + C++ Wayland shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "vxvicfg-shell";
          version = "2.0.0";
          src = ./.;
          nativeBuildInputs = with pkgs; [ cmake ninja pkg-config qt6.wrapQtAppsHook ];
          buildInputs = with pkgs; [
            qt6.qtbase qt6.qtdeclarative qt6.qtwayland
            pipewire wireplumber networkmanager bluez matugen
            pam brightnessctl playerctl
          ];
          cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];
          installPhase = ''
            runHook preInstall
            cmake --install build --prefix $out
            mkdir -p $out/bin
            cat > $out/bin/vxvicfg-shell <<EOF
            #!${pkgs.bash}/bin/bash
            exec ${pkgs.quickshell}/bin/quickshell -p $out/share/quickshell/modules/vxvicfg/shell.qml "\$@"
            EOF
            chmod +x $out/bin/vxvicfg-shell
            runHook postInstall
          '';
        };
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/vxvicfg-shell";
        };
      }) // {
        homeManagerModules.default = { config, lib, pkgs, ... }:
          with lib;
          let cfg = config.programs.vxvicfg-shell;
          in {
            options.programs.vxvicfg-shell = {
              enable = mkEnableOption "vxvicfg Shell";
              package = mkOption {
                type = types.package;
                default = self.packages.${pkgs.system}.default;
              };
              barPosition = mkOption {
                type = types.enum [ "top" "bottom" "left" "right" ];
                default = "left";
              };
              darkMode = mkOption { type = types.bool; default = true; };
            };
            config = mkIf cfg.enable {
              home.packages = [ cfg.package ];
              xdg.configFile."vxvicfg/config.json".text = builtins.toJSON {
                barPosition = cfg.barPosition;
                darkMode = cfg.darkMode;
              };
            };
          };
      };
}
