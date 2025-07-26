module Heroicons
  class Engine < ::Rails::Engine
    isolate_namespace Heroicons

    config.to_prepare do
      ActiveSupport.on_load(:action_view) do
        include Heroicons::ApplicationHelper
      end
    end
  end
end
