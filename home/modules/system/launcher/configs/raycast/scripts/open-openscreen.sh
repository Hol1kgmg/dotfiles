#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title Open Openscreen
# @raycast.mode silent

# Optional parameters
# @raycast.icon 🎬
# @raycast.packageName Openscreen
# @raycast.description 画面収録アプリ Openscreen を起動する

# Electronアプリのため bin/openscreen からは起動できない(helper appを解決できない)。
# home-managerのlinkAppsが配置する.appバンドル経由で起動する。
open -a "$HOME/Applications/Home Manager Apps/Openscreen.app"
