module Heroicons
  module ApplicationHelper
    def icon_tag(name, **options)
      options[:type] ||= :outline
      options[:class] ||= "w-6 h-6"
      name = name.to_s

      searched_paths = []

      # First try app assets
      app_path = File.join(Rails.root, "app/assets/images/icons/#{options[:type]}/#{name}.svg")
      searched_paths << app_path

      if File.exist?(app_path)
        raw File.read(app_path).sub("<svg", "<svg class=\"#{options[:class]}\"")
      else
        # Then try gem assets
        gem_path = File.join(Heroicons.root, "app/assets/images/icons/#{options[:type]}/#{name}.svg")
        searched_paths << gem_path

        if File.exist?(gem_path)
          raw File.read(gem_path).sub("<svg", "<svg class=\"#{options[:class]}\"")
        else
          raise Heroicons::IconNotFoundError.new(name, options[:type], searched_paths)
        end
      end
    end
  end
end
