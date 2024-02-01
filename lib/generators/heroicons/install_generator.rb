module Heroicons
  class InstallGenerator < Rails::Generators::Base
    source_root File.join(__dir__, "templates")

    def copy_helper
      template "heroicons_helper.rb", "app/helpers/heroicons_helper.rb"
    end
  end
end
