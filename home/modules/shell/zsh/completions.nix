{ lib, ... }:

{
  # ~/.zsh/completions 配下のカスタム補完関数(_just等)をcompinitより先にfpathへ追加
  # FPATHをexportすると direnv 等の他プロセス経由で値が上書き・破損しcompinitが壊れるため、
  # zshのfpath配列のみを操作する
  programs.zsh.initContent = lib.mkOrder 550 ''
    fpath=(~/.zsh/completions $fpath)
  '';
}
