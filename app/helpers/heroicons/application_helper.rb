module Heroicons
  module ApplicationHelper
    def icon_tag(name, **options)
      options[:type] ||= Heroicons.configuration.default_type
      options[:class] ||= Heroicons.configuration.default_class
      name = normalize_icon_name(name.to_s)

      icon_path = find_icon_path(name, options[:type])
      render_svg(icon_path, options[:class])
    end

    private
      def normalize_icon_name(name)
        return name unless name.include?("_")

        Rails.logger&.warn(
          "[DEPRECATION] Using underscored icon names like '#{name}' is deprecated. " \
          "Please use dashed names like '#{name.tr('_', '-')}' instead."
        )
        name.tr("_", "-")
      end

      def find_icon_path(name, type)
        app_path = Rails.root.join("app/assets/images/icons/#{type}/#{name}.svg").to_s
        return app_path if File.exist?(app_path)

        gem_path = File.join(Heroicons.root, "app/assets/images/icons/#{type}/#{name}.svg")
        return gem_path if File.exist?(gem_path)

        raise Heroicons::IconNotFoundError.new(name, type, [app_path, gem_path])
      end

      def render_svg(path, css_class)
        raw File.read(path).sub("<svg", "<svg class=\"#{css_class}\"") # rubocop:disable Rails/OutputSafety
      end
  end
end
