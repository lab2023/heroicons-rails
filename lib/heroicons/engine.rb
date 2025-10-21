module Heroicons
  class Engine < ::Rails::Engine
    isolate_namespace Heroicons

    # Configuration options
    config.heroicons = ActiveSupport::OrderedOptions.new
    config.heroicons.auto_sync = false # Set to true to auto-sync icons before asset compilation

    # Load rake tasks
    rake_tasks do
      load File.expand_path("../tasks/heroicons.rake", __dir__)
    end

    config.to_prepare do
      ActiveSupport.on_load(:action_view) do
        include Heroicons::ApplicationHelper
      end
    end

    # Auto-sync icons before asset precompilation if enabled
    config.before_initialize do |app|
      if app.config.heroicons.auto_sync && defined?(Rake) && Rake::Task.task_defined?("assets:precompile")
        Rake::Task["assets:precompile"].enhance(["heroicons:sync"])
      end
    end
  end
end
