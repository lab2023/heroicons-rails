module Heroicons
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Heroicons::Rails
    end
  end
end
