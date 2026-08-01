# help: Homebrew(nix管理)ドリフト確認関数
#
# 【利用可能なコマンド】
#
# brew-nix-list
#   - dotfilesのnix-darwin設定(homebrew.brews/casks)で宣言済みのパッケージ名を表示します
#
# brew-drift
#   - 実際にインストール済みのHomebrewパッケージと、nixで宣言済みのパッケージを比較し、
#     nix側に定義されていないもの(＝ターミナルでbrew installした、または今後cleanup=uninstallで
#     削除される見込みのもの)だけを一覧表示します

{ config, pkgs, ... }:

{
  programs.zsh.initContent = ''
    _brew_nix_dotfiles_dir() {
      if [[ -n "''${DOTFILES_DIR:-}" ]]; then
        echo "$DOTFILES_DIR"
      else
        echo "$HOME/dotfiles"
      fi
    }

    _brew_nix_declared_formulae() {
      nix eval "$(_brew_nix_dotfiles_dir)#darwinConfigurations.default.config.homebrew.brews" --json --impure 2>/dev/null \
        | jq -r '.[].name | sub(".*/"; "")' | sort -u
    }

    _brew_nix_declared_casks() {
      nix eval "$(_brew_nix_dotfiles_dir)#darwinConfigurations.default.config.homebrew.casks" --json --impure 2>/dev/null \
        | jq -r '.[].name' | sort -u
    }

    brew-nix-list() {
      echo "== Formulae (nix declared) =="
      _brew_nix_declared_formulae
      echo "== Casks (nix declared) =="
      _brew_nix_declared_casks
    }

    brew-drift() {
      echo "== Formulae (manual, not in nix) =="
      comm -23 <(brew list --formula -1 | sort) <(_brew_nix_declared_formulae)
      echo "== Casks (manual, not in nix) =="
      comm -23 <(brew list --cask -1 | sort) <(_brew_nix_declared_casks)
    }
  '';
}
