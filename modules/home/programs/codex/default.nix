{
  lib,
  config,
  ...
}: {
  options.my.home.programs.codex.enable = lib.mkEnableOption "codex";

  config = lib.mkIf config.my.home.programs.codex.enable {
    programs.codex = {
      enable = true;

      settings = {
        model = "gpt-5.6-sol";
        model_reasoning_effort = "xhigh";
        personality = "pragmatic";

        approval_policy = "on-request";
        sandbox_mode = "workspace-write";
        web_search = "live";

        # The package is updated through Nix rather than by Codex itself.
        check_for_update_on_startup = false;

        # Keep credentials and tokens out of spawned commands by default.
        shell_environment_policy.ignore_default_excludes = false;
      };

      profiles = {
        fast = {
          model = "gpt-5.6-luna";
          model_reasoning_effort = "medium";
        };

        balanced = {
          model = "gpt-5.6-terra";
          model_reasoning_effort = "high";
        };
      };
    };
  };
}
