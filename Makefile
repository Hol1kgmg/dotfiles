.PHONY: up restart destroy bash claude claude-r init-home init-darwin home darwin update fmt gc

# ===== 環境構築（初回） =====

init-home:
	nix run nixpkgs#home-manager -- switch --flake .#$$(whoami) --impure

init-darwin:
	sudo -H nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#default --impure

# ===== 日常運用 =====

home:
	home-manager switch --flake .#$$(whoami) --impure

darwin:
	sudo darwin-rebuild switch --flake .#default --impure

update:
	nix run .#default --impure

fmt:
	nix fmt

gc:
	nix store gc

# ===== devcontainer =====

up:
	devcontainer up --workspace-folder .

restart:
	devcontainer up --workspace-folder . --remove-existing-container

destroy:
	docker ps -a --filter "label=devcontainer.local_folder=$(PWD)" --format "{{.ID}}" | xargs -r docker rm -f
	docker volume rm -f frontend-env-mask backend-env-mask
	docker volume ls --filter "name=nix-store" --format "{{.Name}}" | xargs -r docker volume rm -f
	docker images --filter "reference=vsc-pj_ai_transcribe_speech-*" --format "{{.ID}}" | xargs -r docker rmi -f

bash:
	devcontainer exec --workspace-folder . bash

claude:
	devcontainer exec --workspace-folder . claude

claude-r:
	devcontainer exec --workspace-folder . claude -r
