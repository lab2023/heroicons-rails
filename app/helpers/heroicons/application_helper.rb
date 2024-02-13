module Heroicons
  module ApplicationHelper
    def render_icon(name, **options)
      name = options[:name] || nil
      type = options[:type] || :outline
      klass = options[:class] || "w-6 h-6"

      path = "assets/images/icons/#{type}/#{name}.svg"
      begin
        icon = File.read(path).sub("<svg", `<svg class="#{klass}" `)
        render icon
      rescue
        "Icon Not Found! path: #{path}"
      end
    end
  end
end
