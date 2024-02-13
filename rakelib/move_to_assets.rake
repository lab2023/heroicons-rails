desc "Move heroicons to assets"
task :move_to_assets do
  # system "git clone https://github.com/tailwindlabs/heroicons.git tmp/heroicons"

  paths_map = {
    "app/assets/images/icons/micro" => "tmp/heroicons/optimized/16/solid",
    "app/assets/images/icons/mini" => "tmp/heroicons/optimized/20/solid",
    "app/assets/images/icons/solid" => "tmp/heroicons/optimized/24/solid",
    "app/assets/images/icons/outline" => "tmp/heroicons/optimized/24/outline"
  }

  paths_map.each do |rails_path, heroicons_path|
    Dir.children(heroicons_path).each do |svg_file_name|
      Dir.mkdir(rails_path) unless File.exist?(rails_path)

      icon = File.read(File.join(heroicons_path, svg_file_name))

      File.write(File.join(rails_path, "#{converter(svg_file_name)}.svg"), icon)
    end
  end
end

def converter(name)
  a = name.split("-")
  a[-1] = a.last[0..-5]
  a.join("_")
end
