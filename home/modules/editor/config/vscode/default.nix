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
    mutableExtensionsDir = false;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
    };
  };
}
