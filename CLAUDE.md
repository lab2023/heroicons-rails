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
rake move_to_assets      # Move icons from tmp/heroicons to app/assets/images/icons/
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