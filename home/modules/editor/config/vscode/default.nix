{ pkgs, ... }:

{
  imports = [
    ./extensions
    ./settings
    ./keybindings
  ];

  # VSCode基本設定
  programs.vscode = {
    enable = true;
    package = pkgs.writeShellScriptBin "code" ''
      exec "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" "$@"
    '';
    mutableExtensionsDir = false;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
    };
  };
}
