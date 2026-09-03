{
  # sudoコマンドをtouchIDで実行許可
  security.pam.services.sudo_local.touchIdAuth = true;
  # tmux内からのsudoでもtouchIDを使えるようにする（bootstrapセッションへの再アタッチ）
  security.pam.services.sudo_local.reattach = true;
}
