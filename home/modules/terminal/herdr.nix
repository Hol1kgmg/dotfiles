{ pkgs, lib, ... }:

let
  src = pkgs.fetchFromGitHub {
    owner = "ogulcancelik";
    repo = "herdr";
    rev = "v0.8.0";
    hash = "sha256-empFQ+hrnCh2JhOzQRWSCLV0YoZC3DXW3bY6k8YuJjk=";
  };

  zigDeps = pkgs.callPackage "${src}/vendor/libghostty-vt/build.zig.zon.nix" {
    name = "herdr-libghostty-vt-zig-cache";
    inherit (pkgs) zstd;
    linkFarm =
      name: entries:
      pkgs.runCommand name { } ''
        mkdir -p $out
        ${lib.concatMapStringsSep "\n" (entry: ''
          cp -rL ${entry.path} $out/${entry.name}
        '') entries}
      '';
  };
in
{
  home.packages = [
    (pkgs.rustPlatform.buildRustPackage {
      pname = "herdr";
      version = "0.8.0";
      inherit src;

      cargoLock = {
        lockFile = "${src}/Cargo.lock";
      };

      nativeBuildInputs =
        with pkgs;
        [
          git
          pkg-config
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
          pkgs.cctools
          pkgs.xcbuild
        ];

      env = {
        LIBGHOSTTY_VT_OPTIMIZE = "ReleaseFast";
        LIBGHOSTTY_VT_SIMD = "true";
        LIBGHOSTTY_VT_ZIG_SYSTEM_DIR = zigDeps;
        ZIG = lib.getExe pkgs.zig_0_15;
      };

      preBuild = ''
        export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-global-cache"
        export ZIG_LOCAL_CACHE_DIR="$TMPDIR/zig-local-cache"
      '';

      doCheck = false;
    })
  ];

  xdg.configFile."herdr/config.toml".source = ./configs/herdr/config.toml;
}
