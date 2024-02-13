module Heroicons
  module ApplicationHelper
    def render_icon(name, **options)
      options[:type] ||= :outline
      options[:class] ||= "w-6 h-6"

      path =  File.join(Heroicons.root, "app/assets/images/icons/#{options[:type]}/#{name}.svg")
      begin
        raw File.read(path).sub("<svg", "<svg class=\"#{options[:class]}\"")
      rescue Errno::ENOENT
        "Icon Not Found! path: #{path}"
      end
    end
  end
end
