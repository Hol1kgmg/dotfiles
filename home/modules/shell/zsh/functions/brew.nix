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
#
# brew-versions
#   - インストール済みのcask/formulaについて、ローカルにインストールされている
#     バージョンディレクトリの最終更新日時とバージョンを一覧表示します(brewが最後に更新した日時の目安)

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
      echo "\033[34;1m==>\033[0m \033[1mFormulae\033[0m"
      _brew_nix_declared_formulae
      echo "\033[34;1m==>\033[0m \033[1mCasks\033[0m"
      _brew_nix_declared_casks
    }

    brew-drift() {
      echo "\033[34;1m==>\033[0m \033[1mFormulae\033[0m"
      comm -23 <(brew list --formula -1 | sort) <(_brew_nix_declared_formulae)
      echo "\033[34;1m==>\033[0m \033[1mCasks\033[0m"
      comm -23 <(brew list --cask -1 | sort) <(_brew_nix_declared_casks)
    }

    _brew_list_versions() {
      local root_dir="$1"
      shift
      local pkg dir latest version
      for pkg in "$@"; do
        dir="$root_dir/$pkg"
        latest=$(ls -td "$dir"/*/ 2>/dev/null | head -1)
        if [[ -n "$latest" ]]; then
          version=$(basename "$latest")
          echo "$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$latest")  $pkg ($version)"
        fi
      done | sort
    }

    brew-versions() {
      echo "installed, last updated"
      echo "\033[34;1m==>\033[0m \033[1mFormulae\033[0m"
      _brew_list_versions "$(brew --cellar)" $(brew list --formula)
      echo "\033[34;1m==>\033[0m \033[1mCasks\033[0m"
      _brew_list_versions "$(brew --caskroom)" $(brew list --cask)
    }
  '';
}
