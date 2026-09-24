{ lib, ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings =
      let
        dir = "$directory";
        git = "($git_branch)( $git_state)( $git_status)";
        env = "($nix_shell)(/$python)(/$rust)";
      in
      {
        add_newline = false;
        format = lib.concatStrings [
          # show previous command run time if longer than 2s
          "[($cmd_duration\n)](bold yellow)"

          # start of prompt
          "╭╴[$os ](white)[](green)"
          "[${dir}](bg:green fg:black)"
          "[](bg:cyan fg:green)"
          "[ ${git}](bg:cyan fg:black)"
          "[](bg:red fg:cyan)"
          "[ ${env}](bg:red fg:black)"
          "[](fg:red)"

          # input
          "$line_break"
          "$character"
        ];
        right_format = lib.concatStrings [
          "[ $memory_usage](bold red)"
          "[ $time](bright-black)"
        ];

        cmd_duration = {
          show_milliseconds = true;
        };
        fill = {
          symbol = " ";
        };
        character = {
          format = "╰╴[($username@$hostname)](bold red)$symbol ";
        };
        continuation_prompt = "[╰❯❯ ](bold green)";

        os = {
          disabled = false;
          format = "$symbol";
        };
        os.symbols = {
          NixOS = "";
          Debian = "";
          Macos = "";
          Windows = "";
        };
        directory = {
          format = "[$read_only](bg:green fg:bold red)$path";
          read_only = "";
          truncation_length = 3;
          truncation_symbol = ".../";
        };
        git_branch = {
          format = "$branch";
        };
        git_state = {
          format = "$state( $progress_current/$progress_total)";
        };
        git_status = {
          format = "$all_status$ahead_behind";
        };
        nix_shell = {
          symbol = "";
          format = "$symbol($name)";
        };
        python = {
          symbol = "";
          format = "$symbol($version)";
        };
        rust = {
          symbol = "";
          format = "$symbol($version)";
        };

        time = {
          disabled = false;
          time_format = "%T";
          format = "$time";
        };
        memory_usage = {
          disabled = false;
          symbol = "";
          format = "$symbol \${ram}( | \${swap})";
        };
      };
  };
}
