{ pkgs, lib, userSettings, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.${userSettings.username} = {
      search = {
        force = true;
        default = "DuckDuckGo";
        privateDefault = "DuckDuckGo";
        order = [ "DuckDuckGo" "Google" ];
        engines = {
          "Bing".metaData.hidden = true;
        };
      };
      
      settings = {
	# personal preferences
	"places.history.enabled" = false;
      };
    };

    policies = {
      # privacy
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisableFormHistory = true;
      
      # no first run stuff
      OverrideFirstRunPage = "";
      DisableProfileImport = true;
      DontCheckDefaultBrowser = true;

      # preferences
      Homepage = {
        URL = "https://lohng.com";
	Locked = false;
      };
      FirefoxHome = {
        Search = false;
	TopSites = false;
	SponsoredTopSites = false;
	Highlights = false;
	Snippets = false;
      };
      FirefoxSuggest = {
        WebSuggestions = false;
	SponsoredSuggestions = false;
	ImproveSuggest = false;
      };
      NewTabPage = false;
      PromptForDownloadLocation = true;

      # unused features
      DisablePocket = true;
      DisableFirefoxScreenshots = true;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      PasswordManagerEnabled = false;

      # Some must have extensions
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
	  default_area = "navbar";
        };
	"{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
	  default_area = "navbar";
	};
        "@testpilot-containers" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
          installation_mode = "force_installed";
	  default_area = "navbar";
        };
      };
    };
  };
}