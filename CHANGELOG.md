# Changelog

All notable changes to this project will be documented in this file.

## [0.5.0] - 2026-01-14

### 🚀 New Features
- **Default Type Configuration**: Configure default icon type via initializer
- **Heroicons Initializer Generator**: New `rails g heroicons:install` generator creates customizable initializer
- **Configuration Options**: Customize default `type` and `class` values globally

### ✨ Enhancements
- Ruby 4.0.0 support
- Improved RuboCop configuration (rubocop-rails-omakase)
- Enhanced gemspec with Ruby 3.3+ compatibility
- Added MFA requirement for RubyGems publishing
- Expanded test coverage for configuration options

### 🔧 Internal
- GitHub Actions checkout upgraded to v5
- Dependency updates (Rails, Puma, SQLite3)

## [0.4.1] - 2025-01-26

### 📝 Documentation Updates
- Fixed README usage examples to use correct dash format (`"x-mark"` instead of `:x_mark`)
- Updated Heroicons version reference to v2.1.5
- Improved consistency in documentation examples

## [0.4.0] - 2025-01-26

### 🚀 Major Features
- **Auto-Integration**: Helper methods are now automatically available in views without running generators
- **Custom Icons Support**: Added support for custom icons via `type: :custom`
- **Proper Error Handling**: `icon_tag` now raises `Heroicons::IconNotFoundError` instead of returning error strings

### ✨ Enhancements
- **Backward Compatibility**: Added support for underscored icon names (`academic_cap`) with deprecation warnings
- **Better Documentation**: Updated README with comprehensive usage examples and custom icon instructions
- **Improved Testing**: Enhanced test coverage for all new features

### 🔧 Breaking Changes
- **No Generator Required**: The `rails g heroicons:install` generator is now optional
- **Exception on Missing Icons**: Missing icons now raise exceptions instead of returning error strings
- **Deprecation Warnings**: Underscored icon names will show deprecation warnings in logs

### 📝 Documentation
- Added comprehensive custom icon usage documentation
- Updated installation instructions (no generator needed)
- Added error handling examples
- Created CLAUDE.md for development guidance

### 🧹 Internal Improvements
- Removed unnecessary generator files
- Improved Rails Engine integration
- Enhanced code structure and maintainability
- Added proper exception classes with detailed error information

### Migration Guide
- **From 0.3.x to 0.4.0**:
  - Remove any `rails g heroicons:install` calls - helpers are auto-included
  - Update any error handling code to catch `Heroicons::IconNotFoundError`
  - Replace underscored icon names with dashed names (e.g., `academic_cap` → `academic-cap`)