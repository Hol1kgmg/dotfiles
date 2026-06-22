{ lib, ... }:
{
  programs.git = {
    enable = true;

    settings = {
      init.defaultBranch = "main";
      pull.rebase = false;
      push.default = "current";
      core.editor = "vim";

      alias.gbdel = "!git branch --merged | grep -Ev '\\*|develop|main' | xargs git branch -d";
    };
  };
}
