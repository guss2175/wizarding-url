Config.setup do |config|
  # Name of the constant exposing loaded settings
  config.const_name = "Settings"

  # Define ENV variable prefix deciding which variables to load into config.
  #
  # Reading variables from ENV is case-sensitive. If you define lowercase value below, ensure your ENV variables are
  # prefixed in the same way.
  #
  # When not set it defaults to `config.const_name`.
  config.env_prefix = "SETTINGS"

  # Evaluate ERB in YAML config files at load time.
  config.evaluate_erb_in_yaml = true
end
