# Heroicons::Rails

## Usage

After installation, helper methods are automatically available in your views:

```erb
<%= icon_tag :x_mark %>
<%= icon_tag :x_mark, class: "bg-red-500" %>
<%= icon_tag :x_mark, type: :mini, class: "bg-red-500" %>
<%= icon_tag :x_mark, type: :solid, class: "w-8 h-8" %>
```

Available icon types:
- `:outline` (default) - 24x24 outline icons
- `:solid` - 24x24 solid icons  
- `:mini` - 20x20 solid icons
- `:micro` - 16x16 solid icons

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
