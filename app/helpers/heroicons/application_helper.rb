module Heroicons
  module ApplicationHelper
    def render_icon(name, **options)
      render "components/icons", name: name, type: options[:type], class: options[:class]
    end
  end
end
