# NOTE: キャッシュの狙いは tool-init-cache.nix を参照。
# oh-my-posh はバイナリ・設定ファイルがどちらも nix store パス(内容が変われば
# 別パスになる)なので、mtime ではなく実行コマンド文字列の変化で再生成を判定する。

{ config, lib, ... }:

let
  cfg = config.programs.oh-my-posh;
  configArgument = lib.optionalString (cfg.configFile != null) "--config ${cfg.configFile}";
  initCmd = "${lib.getExe cfg.package} init zsh ${configArgument}";
in

{
  programs.zsh.initContent = lib.mkIf cfg.enable ''
    _oh_my_posh_init_cache() {
      local cache_dir="''${XDG_CACHE_HOME:-$HOME/.cache}"
      local cache_file="$cache_dir/oh-my-posh-init.zsh"
      local cmd_file="$cache_dir/oh-my-posh-init.cmd"
      local cmd="${initCmd}"

      if [[ ! -f "$cache_file" ]] || [[ "$(cat "$cmd_file" 2>/dev/null)" != "$cmd" ]]; then
        mkdir -p "$cache_dir"
        eval "$cmd" > "$cache_file"
        print -r -- "$cmd" > "$cmd_file"
      fi

      source "$cache_file"
    }
    _oh_my_posh_init_cache
    unfunction _oh_my_posh_init_cache
  '';
}
