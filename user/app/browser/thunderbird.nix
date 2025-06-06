{ pkgs, userSettings, ... }:

{
  programs.thunderbird = {
    enable = true;
    profiles.${userSettings.username} = {
      isDefault = true;
      settings = {
        # sort mails ascending (bottom is latest)
        "mailnews.default_sort_order" = 1;
        # sort mails by date
        "mailnews.default_sort_type" = 18;
        # just check all folder, I can take it
        "mail.server.default.check_all_folders_for_new" = true;

        "mailnews.emptyJunk.dontAskAgain" = true;
      };
    };
  };
}