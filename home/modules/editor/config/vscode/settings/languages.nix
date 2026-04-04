{
  programs.vscode.profiles.default.userSettings = {
    # JavaScript/TypeScript設定
    "javascript.updateImportsOnFileMove.enabled" = "always";
    "typescript.updateImportsOnFileMove.enabled" = "always";

    # Nix設定
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nil";

    # Markdown設定
    "[markdown]" = {
      "editor.wordWrap" = "on";
    };

    # Code Spell Checker設定
    "cSpell.languageSettings" = [
      {
        languageId = "nix";
        enabled = false;
      }
    ];
  };
}
