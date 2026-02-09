{ pkgs, ... }:

let
    keybindings = ''
      [
          {
              "key": "shift+alt+down",
              "command": "editor.action.copyLinesDownAction",
              "when": "editorTextFocus && !editorReadonly"
          },
          {
              "key": "ctrl+shift+alt+down",
              "command": "-editor.action.copyLinesDownAction",
              "when": "editorTextFocus && !editorReadonly"
          },
          {
              "key": "shift+alt+up",
              "command": "editor.action.copyLinesUpAction",
              "when": "editorTextFocus && !editorReadonly"
          },
          {
              "key": "ctrl+shift+alt+up",
              "command": "-editor.action.copyLinesUpAction",
              "when": "editorTextFocus && !editorReadonly"
          },
          {
              "key": "ctrl+alt+up",
              "command": "editor.action.insertCursorAbove",
              "when": "editorTextFocus"
          },
          {
              "key": "shift+alt+up",
              "command": "-editor.action.insertCursorAbove",
              "when": "editorTextFocus"
          },
          {
              "key": "ctrl+alt+down",
              "command": "editor.action.insertCursorBelow",
              "when": "editorTextFocus"
          },
          {
              "key": "shift+alt+down",
              "command": "-editor.action.insertCursorBelow",
              "when": "editorTextFocus"
          }
      ]
    '';
in
{
  home.packages = with pkgs; [
    vscodium
    code-cursor-fhs
  ];

  xdg.configFile = {
    "VSCodium/User/keybindings.json" = {
        text = keybindings;
        force = true;
    };
    "Cursor/User/keybindings.json" = {
        text = keybindings;
        force = true;
    };
  };
}
