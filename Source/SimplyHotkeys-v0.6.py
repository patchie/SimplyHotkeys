#!/usr/bin/env python3.12
"""SimplyHotkeys version 0.6 implemented in Python.

This script provides a minimal GUI for defining up to ten text hotkeys
triggered by Ctrl+1 .. Ctrl+0. It loads and saves configuration from
``SimplyHotkeys.ini`` in the user's home directory. Hotkeys are registered
using the ``keyboard`` library.

Requires Python 3.12 or newer.
"""

from __future__ import annotations

import configparser
import os
import sys
import tkinter as tk
from tkinter import ttk

try:
    import keyboard
except ImportError as exc:  # pragma: no cover - dependency check
    raise SystemExit("The 'keyboard' package is required: pip install keyboard") from exc

if sys.version_info < (3, 12):
    raise SystemExit("Python 3.12 or newer is required")

CONFIG_PATH = os.path.join(os.path.expanduser("~"), "SimplyHotkeys.ini")
HOTKEYS = [f"ctrl+{(i + 1) % 10}" for i in range(10)]


class SimplyHotkeysApp:
    def __init__(self, root: tk.Tk) -> None:
        self.root = root
        self.root.title("SimplyHotkeys 0.6")
        self.enabled = [tk.BooleanVar(value=True) for _ in HOTKEYS]
        self.text = [tk.StringVar() for _ in HOTKEYS]
        self._load_config()
        self._build_gui()
        self._register_hotkeys()

    def _load_config(self) -> None:
        config = configparser.ConfigParser()
        config.read(CONFIG_PATH)
        for i in range(len(HOTKEYS)):
            hk_key = f"Hotkey{i+1}"
            self.enabled[i].set(
                config.getboolean("Hotkeys", f"Hotkey_enabled{i+1}", fallback=True)
            )
            self.text[i].set(config.get("Hotkeys", hk_key, fallback="").replace("|", "\n"))

    def _save_config(self) -> None:
        cfg = configparser.ConfigParser()
        cfg["Hotkeys"] = {}
        for i in range(len(HOTKEYS)):
            cfg["Hotkeys"][f"Hotkey_enabled{i+1}"] = str(int(self.enabled[i].get()))
            cfg["Hotkeys"][f"Hotkey{i+1}"] = self.text[i].get().replace("\n", "|")
        with open(CONFIG_PATH, "w", encoding="utf-8") as fh:
            cfg.write(fh)

    def _register_hotkeys(self) -> None:
        keyboard.unhook_all_hotkeys()
        for i, hotkey in enumerate(HOTKEYS):
            if self.enabled[i].get():
                text = self.text[i].get()
                keyboard.add_hotkey(hotkey, lambda t=text: keyboard.write(t))

    def _build_gui(self) -> None:
        for i, hotkey in enumerate(HOTKEYS):
            cb = ttk.Checkbutton(self.root, text=hotkey, variable=self.enabled[i])
            cb.grid(row=i, column=0, sticky="w", padx=5, pady=2)
            entry = ttk.Entry(self.root, textvariable=self.text[i], width=40)
            entry.grid(row=i, column=1, padx=5, pady=2)
        save_btn = ttk.Button(self.root, text="Save", command=self._on_save)
        save_btn.grid(row=len(HOTKEYS), column=0, columnspan=2, pady=10)

    def _on_save(self) -> None:
        self._save_config()
        self._register_hotkeys()


def main() -> None:
    root = tk.Tk()
    app = SimplyHotkeysApp(root)
    root.mainloop()


if __name__ == "__main__":
    main()
