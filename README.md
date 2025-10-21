# Heroicons::Rails

A Rails integration for [Heroicons](https://heroicons.com/) - Beautiful hand-crafted SVG icons by the makers of Tailwind CSS.

**Heroicons Version**: v2.1.5

## Usage

After installation, helper methods are automatically available in your views:

```erb
<%= icon_tag "x-mark" %>
<%= icon_tag "x-mark", class: "bg-red-500" %>
<%= icon_tag "x-mark", type: :mini, class: "bg-red-500" %>
<%= icon_tag "academic-cap", type: :solid, class: "w-8 h-8" %>
```

Available icon types:
- `:outline` (default) - 24x24 outline icons
- `:solid` - 24x24 solid icons
- `:mini` - 20x20 solid icons
- `:micro` - 16x16 solid icons
- `:custom` - Custom icons (place in `app/assets/images/icons/custom/`)

## Custom Icons

You can add your own custom icons by creating the directory structure and using the `:custom` type:

```
app/assets/images/icons/custom/
├── my-logo.svg
├── custom-arrow.svg
└── company-icon.svg
```

```erb
<%= icon_tag "my-logo", type: :custom %>
<%= icon_tag "custom-arrow", type: :custom, class: "w-4 h-4" %>
```

## Icon Management

The gem includes intelligent icon management that keeps your assets directory clean and optimized:

### Automatic Icon Syncing

Only include icons you actually use in your application's assets:

```bash
# Scan your app and sync icons (copies used icons, removes unused ones)
$ rake heroicons:sync

# Preview what would be synced without making changes
$ rake heroicons:dry_run

# List all icons currently used in your application
$ rake heroicons:list_used
```

### How It Works

1. The scanner searches your Rails app for `icon_tag` usage in views, helpers, and components
2. Only the icons you're actually using are copied to `app/assets/images/icons/`
3. Icons you've removed from your code are automatically deleted from assets
4. Your repository stays clean with only the icons you need

### Benefits

- **Smaller asset bundles**: Only includes icons you use
- **Automatic cleanup**: Removes unused icons automatically
- **Easy auditing**: See exactly which icons your app uses
- **Version control friendly**: Only commit icons you actually need

### Optional Auto-sync

Enable automatic syncing before asset precompilation:

```ruby
# config/application.rb
config.heroicons.auto_sync = true
```

When enabled, icons will be automatically synced before `rake assets:precompile` runs.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "heroicons-rails", github: "lab2023/heroicons-rails", branch: "main"
```

And then execute:
```bash
$ bundle
```

## Contributing
Once you've made your great commits:

1. Fork Template
2. Create a topic branch - `git checkout -b my_branch`
3. Push to your branch - `git push origin my_branch`
4. Create a Pull Request from your branch
5. That's it!

## Credits
![lab2023](http://lab2023.com/assets/images/named-logo.png)

- heroicons-rails is maintained and funded by [lab2023 - information technologies](http://lab2023.com/)
- Thank you to all the [contributors!](../../graphs/contributors)
- This gem uses [Heroicons](https://heroicons.com/)
- The names and logos for lab2023 are trademarks of lab2023, inc.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
Copyright © 2013-2024 [lab2023 - information technologies](http://lab2023.com)
