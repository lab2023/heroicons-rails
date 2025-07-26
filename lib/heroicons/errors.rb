module Heroicons
  class IconNotFoundError < StandardError
    attr_reader :icon_name, :icon_type, :searched_paths

    def initialize(icon_name, icon_type, searched_paths)
      @icon_name = icon_name
      @icon_type = icon_type
      @searched_paths = searched_paths
      super(build_message)
    end

    private

    def build_message
      "Icon '#{icon_name}' of type '#{icon_type}' not found. Searched paths: #{searched_paths.join(', ')}"
    end
  end
end
