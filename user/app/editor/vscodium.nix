{ pkgs, ... }

{
  home.packges = with pkgs; [
    vscodium
  ];

  home.file = {
    ".config/VSCodium/User/keybindings.json" = {
    text = ''
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
    mutable = true;
    };
  };
}
