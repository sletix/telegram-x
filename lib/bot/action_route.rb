module Bot

  # module with schema classes for define bot behavior states
  #
  module ActionRoute
    Map = YAML.load_file("#{APP_ROOT}/config/routes.yml")

    def available? cmd
      Map.has_key? cmd
    end

    def get_route cmd
      Map[cmd]
    end

    def is_alias? cmd
      get_route(cmd).to_s[0] == "/"# if available? cmd
    end

    def get_schema_class cmd
      return unless available? cmd
      name = is_alias?(cmd) ? get_route(cmd) : cmd
      "bot/action_route#{name}_schema".classify.safe_constantize or DefaultSchema
    end

    extend self
  end
end
