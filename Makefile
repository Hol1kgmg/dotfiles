.PHONY: init-home init-darwin

# ===== 環境構築（初回） =====

init-home:
	nix run nixpkgs#home-manager -- switch --flake .#$$(whoami) --impure

init-darwin:
	sudo -H nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#default --impure
