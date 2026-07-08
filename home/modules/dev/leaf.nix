{ pkgs, lib, ... }:

# markdown viewツール moの導入によりコメントアウト
let
  leaf = pkgs.rustPlatform.buildRustPackage {
    pname = "leaf";
    version = "1.22.0";

    src = pkgs.fetchFromGitHub {
      owner = "RivoLink";
      repo = "leaf";
      rev = "1.22.0";
      hash = "sha256-ZnTHFVvSWYhxwRo2y2hm+XxwWufcmnHftFfX9N74PNo=";
    };

    cargoHash = "sha256-5iPzixJ+nGpfmEAdsgiKqYg8CDQ3QAGd5kGdDW4+fnU=";

    meta = {
      description = "A simple CLI tool for managing git worktrees";
      homepage = "https://github.com/RivoLink/leaf";
      license = lib.licenses.mit;
      platforms = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    };
  };
in
{
  home.packages = [ leaf ];

  xdg.configFile."leaf/config.toml".text = ''
    editor = "nvim"
  '';
}
