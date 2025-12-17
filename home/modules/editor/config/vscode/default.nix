{ pkgs, ... }:

{
  imports = [
    ./extensions
    ./settings
    ./keybindings
  ];

  # VSCode基本設定
  programs.vscode = {
    mutableExtensionsDir = false;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
    };
  };
}
