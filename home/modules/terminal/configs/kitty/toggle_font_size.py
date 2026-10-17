# Zen モード用フォントサイズトグル (WezTerm の toggle-font-size イベント相当)
# kitty の change_font_size は絶対値/リセットのみで往復できないため、現在値を見て切り替える
from kittens.tui.handler import result_handler
from kitty.fast_data_types import os_window_font_size

ZEN_SIZE = 18.0


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    current = os_window_font_size(boss.active_window.os_window_id)
    if current >= ZEN_SIZE:
        boss.restore_font_size()
    else:
        boss.set_font_size(ZEN_SIZE)
