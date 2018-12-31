{ name, config, lib, ... }:

with lib;

let

  addr = "${config.username}@${name}";

  imapAddr = "imap://${addr}"
    + optionalString (config.imapPort != null) ":${toString config.imapPort}";

  smtpAddr = "smtp://${addr}"
    + optionalString (config.smtpPort != null) ":${toString config.smtpPort}";

in

  {
    options = {
      smtpPort = mkOption {
        type = with types; nullOr port;
        default = null;
        description = "The SMTP port that ${name} will listen on.";
      };

      imapPort = mkOption {
        type = with types; nullOr port;
        default = null;
        description = "The IMAP port that ${name} will listen on.";
      };

      username = mkOption {
        type = types.str;
        description = "A username to log in with.";
      };

      password = mkOption {
        type = types.str;
        description = ''
          A password to log in with. Note that it can be any
          string, including an environmental variable like $EWS_PASSWD.
        '';
      };

      configText = mkOption {
        type = types.lines;
        description = ''
          The configuration text for ${name}.
        '';
      };
    };

    config = {
      configText = ''
        mailboxes ${imapAddr}/Inbox
        account-hook ${imapAddr} "set imap_user = ${config.username}"
        account-hook ${imapAddr} "set imap_pass = ${config.password}"
        account-hook ${imapAddr} "set from = ${addr}"
        folder-hook ${imapAddr} "set folder = ${imapAddr}"
        folder-hook ${imapAddr} "set smtp_url = ${smtpAddr}"
        folder-hook ${imapAddr} "set smtp_pass = ${config.password}"
      '';
    };
  }
