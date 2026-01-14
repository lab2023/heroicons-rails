require "rails/generators"

module Heroicons
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Creates a Heroicons initializer file"

      def copy_initializer
        template "initializer.rb", "config/initializers/heroicons.rb"
      end
    end
  end
end
