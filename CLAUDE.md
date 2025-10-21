# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Ruby gem called `heroicons-rails` that provides Heroicons SVG icons as a Rails component library. The gem allows Rails applications to easily use Heroicons via helper methods.

## Key Architecture

- **Rails Engine**: Uses Rails Engine architecture (`lib/heroicons/engine.rb`) to integrate with Rails applications
- **Asset Pipeline**: SVG icons are stored in `app/assets/images/icons/` with subdirectories for different icon types:
  - `outline/` - 24x24 outline icons
  - `solid/` - 24x24 solid icons  
  - `mini/` - 20x20 solid icons
  - `micro/` - 16x16 solid icons
- **Helper Method**: Main functionality provided through `icon_tag` helper in `app/helpers/heroicons/application_helper.rb`
- **Generator**: Installation generator at `lib/generators/heroicons/install_generator.rb` creates helper file in host applications

## Development Commands

### Testing
```bash
rake test                # Run all tests
bundle exec rake test    # Run tests with bundler
```

### Linting  
```bash
bundle exec rubocop      # Run RuboCop linter (uses rubocop-rails-omakase)
```

### Icon Management
```bash
rake move_to_assets           # Move icons from tmp/heroicons to app/assets/images/icons/
rake heroicons:sync           # Sync icons: copy used icons, remove unused ones
rake heroicons:dry_run        # Preview what would be synced (dry run)
rake heroicons:list_used      # List all icons currently used in the application
```

### Gem Development
```bash
bundle install           # Install dependencies
bundle exec rake         # Default task (runs tests)
```

## Usage Pattern

The gem is designed to be included in Rails applications via:

1. Add to Gemfile: `gem "heroicons-rails", github: "lab2023/heroicons-rails", branch: "main"`
2. Helper methods are automatically available in views (no generator needed)
3. Use in views: `<%= icon_tag :x_mark %>` or `<%= icon_tag :x_mark, type: :mini, class: "bg-red-500" %>`

## Auto-Integration

- Helper methods are automatically included via Rails Engine `config.to_prepare` hook
- No manual installation or generator required
- Generator (`rails g heroicons:install`) is optional for custom helper modifications

## File Structure Notes

- Icons are organized by type (outline/solid/mini/micro) corresponding to different sizes and styles from Heroicons
- The `icon_tag` helper defaults to `:outline` type and `"w-6 h-6"` classes
- Icon lookup first checks the Rails app's assets, then falls back to the gem's assets
- The `move_to_assets` rake task syncs icons from the upstream Heroicons repository

## Automatic Icon Management

The gem includes an intelligent icon management system that automatically manages which icons are included in your Rails application's assets:

### How It Works

1. **IconScanner**: Scans your Rails application code (views, helpers, components, controllers) for `icon_tag` usage
2. **IconSyncer**: Copies only the used icons from the gem to your app's `app/assets/images/icons/` directory and removes unused ones

### Usage in Host Applications

**Manual Sync** (recommended workflow):
```bash
# Preview what would change
rake heroicons:sync

# List all icons currently used
rake heroicons:list_used

# Preview sync without making changes
rake heroicons:dry_run
```

**Auto-sync on Asset Precompilation** (optional):
```ruby
# config/application.rb
config.heroicons.auto_sync = true  # Auto-sync before assets:precompile
```

### Benefits

- **Smaller asset size**: Only includes icons you actually use
- **Clean assets directory**: Automatically removes icons when you stop using them
- **Version control friendly**: Your app only commits the icons it needs
- **Easy auditing**: Use `rake heroicons:list_used` to see all icons in use

### Technical Details

- **IconScanner** (`lib/heroicons/icon_scanner.rb`): Searches for `icon_tag` calls using regex patterns
- **IconSyncer** (`lib/heroicons/icon_syncer.rb`): Manages copying/removing icon files
- **Rake Tasks** (`lib/tasks/heroicons.rake`): Provides CLI commands for icon management
- Supports all icon name formats: symbols, strings, underscored, and dashed names
- Automatically normalizes underscored names to dashed format for file lookup