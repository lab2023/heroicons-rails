desc "Download heroicons and convert Rails partials"
task :to_partial do
  system "git clone https://github.com/tailwindlabs/heroicons.git tmp/heroicons"

  paths_map = {
    "app/views/components/icons/micro" => "tmp/heroicons/optimized/16/solid",
    "app/views/components/icons/mini" => "tmp/heroicons/optimized/20/solid",
    "app/views/components/icons/solid" => "tmp/heroicons/optimized/24/solid",
    "app/views/components/icons/outline" => "tmp/heroicons/optimized/24/outline"
  }

  paths_map.each do |rails_path, heroicons_path|
    Dir.children(heroicons_path).each do |svg_file_name|
      Dir.mkdir(rails_path) unless File.exist?(rails_path)
      icon = File.read(File.join(heroicons_path, svg_file_name)).sub("<svg", '<svg class="<%= local_assigns[:class].presence || "w-6 h-6" %>"')

      File.write(File.join(rails_path, "_#{converter(svg_file_name)}.html.erb"), icon)
    end
  end
end

def converter(name)
  a = name.split("-")
  a[-1] = a.last[0..-5]
  a.join("_")
end
