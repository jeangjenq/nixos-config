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

        "mailnews.emptyJunk.dontAskAgain" = true;
      };
      search.default = "DuckDuckGo";
    };
  };
}