module Heroicons
  module ApplicationHelper
    def icon_tag(name, **options)
      options[:type] ||= Heroicons.configuration.default_type
      options[:class] ||= Heroicons.configuration.default_class
      original_name = name.to_s

      # Check for underscore usage and warn about deprecation
      if original_name.include?("_")
        Rails.logger&.warn(
          "[DEPRECATION] Using underscored icon names like '#{original_name}' is deprecated. " \
          "Please use dashed names like '#{original_name.tr('_', '-')}' instead."
        )
        # Convert underscores to dashes for file lookup
        name = original_name.tr("_", "-")
      else
        name = original_name
      end

      searched_paths = []

      # First try app assets
      app_path = Rails.root.join("app/assets/images/icons/#{options[:type]}/#{name}.svg").to_s
      searched_paths << app_path

      if File.exist?(app_path)
        raw File.read(app_path).sub("<svg", "<svg class=\"#{options[:class]}\"")
      else
        # Then try gem assets
        gem_path = File.join(Heroicons.root, "app/assets/images/icons/#{options[:type]}/#{name}.svg")
        searched_paths << gem_path

        raise Heroicons::IconNotFoundError.new(original_name, options[:type], searched_paths) unless File.exist?(gem_path)

        raw File.read(gem_path).sub("<svg", "<svg class=\"#{options[:class]}\"")
      end
    end
  end
end
