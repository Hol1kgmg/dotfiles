{ pkgs, ... }:

let
  version = "0.1.18";

  platformInfo = {
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      hash = "sha256-BghtwJY4GqbSKYqeMGThDJWDRZUA/FgpQFcA4KkRLDA=";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      hash = "sha256-4gDbdZ0MpdlAG4QGLnKblinEjjxKsIidnembEdErdno=";
    };
  };

  info = platformInfo.${pkgs.stdenv.hostPlatform.system};

  vite-plus = pkgs.stdenv.mkDerivation {
    pname = "vite-plus";
    inherit version;

    src = pkgs.fetchzip {
      url = "https://registry.npmjs.org/@voidzero-dev/vite-plus-cli-${info.platform}/-/vite-plus-cli-${info.platform}-${version}.tgz";
      hash = info.hash;
      stripRoot = true;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      mkdir -p $out/bin
      cp vp $out/bin/vp
      chmod +x $out/bin/vp
    '';

    meta = {
      description = "Unified toolchain for web development (Vite, Vitest, Oxlint, etc.)";
      homepage = "https://viteplus.dev";
      platforms = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    };
  };
in
{
  home.packages = [ vite-plus ];
}
