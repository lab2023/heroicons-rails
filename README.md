# Heroicons::Rails

A Rails integration for [Heroicons](https://heroicons.com/) - Beautiful hand-crafted SVG icons by the makers of Tailwind CSS.

**Heroicons Version**: v2.1.5

## Installation

Add this line to your application's Gemfile:

```ruby
gem "heroicons-rails", github: "lab2023/heroicons-rails", branch: "main"
```

And then execute:
```bash
$ bundle
```

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

## Configuration

You can customize the default icon type and CSS classes by creating an initializer:

```bash
$ rails generate heroicons:install
```

This will create `config/initializers/heroicons.rb`:

```ruby
Heroicons.configure do |config|
  # Default icon type (:outline, :solid, :mini, :micro, :custom)
  config.default_type = :solid

  # Default CSS classes applied to icons
  config.default_class = "w-5 h-5"
end
```

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
