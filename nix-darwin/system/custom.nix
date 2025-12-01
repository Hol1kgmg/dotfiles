{ ... }:

{
  # ========================================
  # CustomUserPreferences
  # nix-darwinで標準サポートされていない設定をここで管理
  # ========================================

  system.defaults.CustomUserPreferences = {
    # 現在デフォルトから変更している設定なし
    # 必要に応じて以下のような設定を追加可能:
    # "com.apple.desktopservices".DSDontWriteNetworkStores = true;
    # "com.apple.Safari".ShowFullURLInSmartSearchField = true;
  };
}
