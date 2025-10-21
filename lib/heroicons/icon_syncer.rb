require "fileutils"

module Heroicons
  # Syncs icons from gem to Rails app assets based on usage
  # Copies only used icons and removes unused ones
  class IconSyncer
    ICON_TYPES = %i[outline solid mini micro].freeze

    attr_reader :rails_root, :scanner

    def initialize(rails_root = Rails.root, scanner: nil)
      @rails_root = rails_root
      @scanner = scanner || IconScanner.new(rails_root)
    end

    # Syncs icons: copies used ones from gem, removes unused ones from app
    # Returns stats hash with copied, removed, and kept counts
    def sync!
      used_icons = scanner.scan_used_icons
      stats = { copied: 0, removed: 0, kept: 0, errors: [] }

      ICON_TYPES.each do |type|
        sync_icons_for_type(type, used_icons[type] || [], stats)
      end

      log_sync_results(stats)
      stats
    end

    # Dry run - shows what would be synced without making changes
    def dry_run
      used_icons = scanner.scan_used_icons
      report = { would_copy: [], would_remove: [], would_keep: [] }

      ICON_TYPES.each do |type|
        analyze_sync_for_type(type, used_icons[type] || [], report)
      end

      report
    end

    private

    def sync_icons_for_type(type, used_icon_names, stats)
      app_icons_dir = app_icons_path(type)
      gem_icons_dir = gem_icons_path(type)

      # Create directory if it doesn't exist
      FileUtils.mkdir_p(app_icons_dir) unless used_icon_names.empty?

      # Get currently existing icons in app
      existing_icons = existing_app_icons(type)

      # Copy used icons that don't exist or are outdated
      used_icon_names.each do |icon_name|
        icon_file = "#{icon_name}.svg"
        gem_icon_path = File.join(gem_icons_dir, icon_file)
        app_icon_path = File.join(app_icons_dir, icon_file)

        if File.exist?(gem_icon_path)
          if !File.exist?(app_icon_path) || file_needs_update?(gem_icon_path, app_icon_path)
            FileUtils.cp(gem_icon_path, app_icon_path)
            stats[:copied] += 1
          else
            stats[:kept] += 1
          end
        else
          stats[:errors] << "Icon not found in gem: #{type}/#{icon_name}"
        end
      end

      # Remove icons that are no longer used
      unused_icons = existing_icons - used_icon_names.map { |n| "#{n}.svg" }
      unused_icons.each do |icon_file|
        app_icon_path = File.join(app_icons_dir, icon_file)
        FileUtils.rm(app_icon_path) if File.exist?(app_icon_path)
        stats[:removed] += 1
      end

      # Remove directory if empty
      FileUtils.rmdir(app_icons_dir) if Dir.empty?(app_icons_dir) && Dir.exist?(app_icons_dir)
    rescue => e
      stats[:errors] << "Error syncing #{type} icons: #{e.message}"
    end

    def analyze_sync_for_type(type, used_icon_names, report)
      existing_icons = existing_app_icons(type)
      gem_icons_dir = gem_icons_path(type)

      used_icon_names.each do |icon_name|
        icon_file = "#{icon_name}.svg"
        app_icon_path = File.join(app_icons_path(type), icon_file)

        if File.exist?(app_icon_path)
          report[:would_keep] << "#{type}/#{icon_file}"
        elsif File.exist?(File.join(gem_icons_dir, icon_file))
          report[:would_copy] << "#{type}/#{icon_file}"
        end
      end

      unused_icons = existing_icons - used_icon_names.map { |n| "#{n}.svg" }
      unused_icons.each do |icon_file|
        report[:would_remove] << "#{type}/#{icon_file}"
      end
    end

    def app_icons_path(type)
      File.join(rails_root, "app/assets/images/icons/#{type}")
    end

    def gem_icons_path(type)
      File.join(Heroicons.root, "app/assets/images/icons/#{type}")
    end

    def existing_app_icons(type)
      icons_dir = app_icons_path(type)
      return [] unless Dir.exist?(icons_dir)

      Dir.children(icons_dir).select { |f| f.end_with?(".svg") }
    end

    def file_needs_update?(source, destination)
      File.mtime(source) > File.mtime(destination)
    rescue
      true
    end

    def log_sync_results(stats)
      return unless Rails.logger

      Rails.logger.info("[Heroicons] Icon sync complete:")
      Rails.logger.info("  - Copied: #{stats[:copied]}")
      Rails.logger.info("  - Removed: #{stats[:removed]}")
      Rails.logger.info("  - Kept: #{stats[:kept]}")

      stats[:errors].each do |error|
        Rails.logger.warn("  - #{error}")
      end
    end
  end
end
