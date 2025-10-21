module Heroicons
  # Scans Rails application for icon_tag usage to determine which icons are being used
  class IconScanner
    # Matches: icon_tag(:name), icon_tag("name"), icon_tag :name, icon_tag "name"
    # Also captures type parameter if present: type: :solid
    ICON_TAG_PATTERN = /icon_tag\s*\(?\s*[:"']([a-z_-]+)["']?\s*(?:,\s*type:\s*:([a-z]+))?\)?/i
    SEARCHABLE_EXTENSIONS = %w[.erb .haml .slim .rb].freeze

    attr_reader :rails_root

    def initialize(rails_root = Rails.root)
      @rails_root = rails_root
    end

    # Returns a hash of used icons grouped by type
    # Example: { outline: ['x-mark', 'home'], solid: ['check'], mini: ['star'] }
    def scan_used_icons
      used_icons = Hash.new { |h, k| h[k] = Set.new }

      searchable_files.each do |file_path|
        content = File.read(file_path)
        extract_icons_from_content(content, used_icons)
      end

      # Convert sets to sorted arrays
      used_icons.transform_values { |set| set.to_a.sort }
    rescue => e
      Rails.logger&.error("[Heroicons] Error scanning for icons: #{e.message}")
      {}
    end

    private

    def searchable_files
      search_paths = [
        File.join(rails_root, "app/views/**/*"),
        File.join(rails_root, "app/helpers/**/*"),
        File.join(rails_root, "app/components/**/*"),
        File.join(rails_root, "app/controllers/**/*")
      ]

      search_paths.flat_map do |pattern|
        Dir.glob(pattern).select do |path|
          File.file?(path) && SEARCHABLE_EXTENSIONS.any? { |ext| path.end_with?(ext) }
        end
      end
    end

    def extract_icons_from_content(content, used_icons)
      content.scan(ICON_TAG_PATTERN) do |match|
        icon_name = match[0]&.strip
        icon_type = match[1]&.strip&.to_sym || :outline

        next unless icon_name

        # Normalize icon name: convert underscores to dashes
        normalized_name = icon_name.tr("_", "-")
        used_icons[icon_type] << normalized_name
      end
    end
  end
end
