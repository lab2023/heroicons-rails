namespace :heroicons do
  desc "Sync icons: copy used icons from gem to app/assets, remove unused ones"
  task sync: :environment do
    require "heroicons-rails"

    puts "Scanning application for icon usage..."
    syncer = Heroicons::IconSyncer.new

    stats = syncer.sync!

    puts "\n✓ Icon sync complete!"
    puts "  #{stats[:copied]} icons copied"
    puts "  #{stats[:removed]} icons removed"
    puts "  #{stats[:kept]} icons already up to date"

    if stats[:errors].any?
      puts "\n⚠ Warnings:"
      stats[:errors].each { |err| puts "  - #{err}" }
    end
  end

  desc "Show which icons would be synced (dry run)"
  task dry_run: :environment do
    require "heroicons-rails"

    puts "Analyzing icon usage..."
    syncer = Heroicons::IconSyncer.new

    report = syncer.dry_run

    puts "\n--- Dry Run Report ---"

    if report[:would_copy].any?
      puts "\nWould COPY (#{report[:would_copy].size}):"
      report[:would_copy].each { |icon| puts "  + #{icon}" }
    end

    if report[:would_remove].any?
      puts "\nWould REMOVE (#{report[:would_remove].size}):"
      report[:would_remove].each { |icon| puts "  - #{icon}" }
    end

    if report[:would_keep].any?
      puts "\nWould KEEP (#{report[:would_keep].size}):"
      report[:would_keep].each { |icon| puts "  = #{icon}" }
    end

    puts "\nRun 'rake heroicons:sync' to apply these changes."
  end

  desc "List all icons currently used in the application"
  task list_used: :environment do
    require "heroicons-rails"

    puts "Scanning application for icon usage...\n"
    scanner = Heroicons::IconScanner.new

    used_icons = scanner.scan_used_icons

    if used_icons.empty?
      puts "No icons found in use."
    else
      total = used_icons.values.sum(&:size)
      puts "Found #{total} unique icons in use:\n\n"

      used_icons.each do |type, icons|
        next if icons.empty?

        puts "#{type.to_s.upcase} (#{icons.size}):"
        icons.each { |icon| puts "  - #{icon}" }
        puts ""
      end
    end
  end
end
