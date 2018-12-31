{ config, pkgs, lib, ... }:

let

  cfg = config.programs.neomutt;

  mailboxes = import ./mailboxes.nix;

in

  {
    options = with lib; {
      programs.neomutt = {
        enable = mkEnableOption ''
          Whether to enable neomutt, a command line mail user agent.
        '';

        mailboxes = mkOption {
          type = with types; attrsOf (submodule mailboxes);
          default = {};
          description = ''
            Mailboxes to add to the neomutt configuration.
          '';
        };

        realname = mkOption {
          type = with types; nullOr str;
          default = null;
          description = ''
            Your real name.
          '';
        };

        attribution = mkOption {
          type = with types; nullOr str;
          default = null;
          description = ''
            The attribution format string.
          '';
        };

        extraConfig = mkOption {
          type = with types; nullOr lines;
          default = null;
          description = ''
            Extra configuration lines to add to neomuttrc.
          '';
        };
      };
    };

    config = with lib; mkIf cfg.enable {
      home.files.".config/neomutt/neomuttrc".text = ''
        ${concatStringsSep "\n" (
          map (x: x.configText) (attrValues cfg.mailboxes)
        )}
      ''+ optionalString (cfg.realname != null) ''
        set realname = "${cfg.realname}"
      '' + optionalString (cfg.attribution != null) ''
        set attribution = ${strings.escapeNixString cfg.attribution}
      '' + ''
        set spoolfile = "=Inbox"
        set trash = "=Trash"

        set header_cache = ~/.mutt/cache/headers
        set message_cachedir = ~/.mutt/cache/bodies
        set certificate_file = ~/.mutt/certificates
      '' + optionalString (cfg.extraConfig != null) cfg.extraConfig;

      home.files.".mailcap".text = with pkgs; ''
        text/html; ${w3m}/bin/w3m -I %{charset} -T text/html; copiousoutput;
        text/calendar; ${khal}/bin/khal printics; copiousoutput;
        image/*; ${feh}/bin/feh %s;
      '';

      home.files.".config/khal/config".text = ''
        [calendars]

        [[private]]
        path = /home/sean/.local/share/khal/calendars/private
        type = calendar

        [locale]
        timeformat = %H:%M
        dateformat = %Y-%m-%d
        longdateformat = %Y-%m-%d
        datetimeformat = %Y-%m-%d %H:%M
        longdatetimeformat = %Y-%m-%d %H:%M
      '';
    };
  }
