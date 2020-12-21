from os import path
import subprocess
import json
from settings.path import qtile_path

def get_theme():
    theme = "dracula"
    theme_file = path.join(qtile_path, "themes", f'{theme}.json')

    if not path.isfile(theme_file):
        raise Exception(f'"{theme_file}" does not exist')

    with open(path.join(theme_file)) as file:
        return json.load(file)

def get_font():
    font = "hack"
    font_file = path.join(qtile_path, "fonts", f'{font}.json')

    if not path.isfile(font_file):
        raise Exception(f'"{font_file}" does not exist')

    with open(path.join(font_file)) as file:
        return json.load(file)


if __name__ == "settings.theme":
    theme = get_theme()
    font = get_font()
