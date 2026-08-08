# NOTE: mise/zoxide/fzf の shell 統合スクリプト(`eval "$(mise activate zsh)"` 等)を
# キャッシュし、起動毎のサブプロセス生成コストを省く(oh-my-posh-init-cache.nix も同じ方針)。
# バイナリの実体(nix store パス)が変わった時だけ再生成する。
# 各ツールの home-manager 側 enableZshIntegration は false にして自動 eval と重複させない。

{ config, pkgs, ... }:

{
  programs.zsh.initContent = ''
    _tool_init_cache() {
      local name="$1"
      shift
      local cache_dir="''${XDG_CACHE_HOME:-$HOME/.cache}"
      local cache_file="$cache_dir/''${name}-init.zsh"
      local bin_path

      bin_path="$(command -v "$name" 2>/dev/null)"
      [[ -z "$bin_path" ]] && return
      bin_path="$(readlink -f "$bin_path" 2>/dev/null || echo "$bin_path")"

      if [[ ! -f "$cache_file" ]] || [[ "$bin_path" -nt "$cache_file" ]]; then
        mkdir -p "$cache_dir"
        "$bin_path" "$@" > "$cache_file"
      fi

      source "$cache_file"
    }

    _tool_init_cache mise activate zsh
    _tool_init_cache zoxide init zsh
    _tool_init_cache fzf --zsh
    unfunction _tool_init_cache
  '';
}
