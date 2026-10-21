# Orca: AIエージェント用IDE (試用中、docs/adr/terminal-env/0007-trial-orca.md)
# ~/.orca には worktree やエージェント状態も入るため、keybindings.json のみファイル単位でリンクする
{ ... }:

{
  home.file.".orca/keybindings.json".source = ./configs/orca/keybindings.json;
}
