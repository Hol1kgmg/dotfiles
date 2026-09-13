#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title Open Openscreen Data Folder
# @raycast.mode silent

# Optional parameters
# @raycast.icon 📂
# @raycast.packageName Openscreen
# @raycast.description Openscreenのデータディレクトリ(録画データを含む)をFinderで開く

# 録画データは この配下の recordings/ に保存される。
open "$HOME/Library/Application Support/openscreen"
