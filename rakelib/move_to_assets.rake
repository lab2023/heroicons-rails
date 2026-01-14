desc "Move heroicons to assets"
task move_to_assets: :environment do
  # system "git clone https://github.com/tailwindlabs/heroicons.git tmp/heroicons"

  paths_map = {
    "app/assets/images/icons/micro" => "tmp/heroicons/optimized/16/solid",
    "app/assets/images/icons/mini" => "tmp/heroicons/optimized/20/solid",
    "app/assets/images/icons/solid" => "tmp/heroicons/optimized/24/solid",
    "app/assets/images/icons/outline" => "tmp/heroicons/optimized/24/outline"
  }

  paths_map.each do |rails_path, heroicons_path|
    Dir.children(heroicons_path).each do |svg_file_name|
      FileUtils.mkdir_p(rails_path)

      icon = File.read(File.join(heroicons_path, svg_file_name))

      File.write(File.join(rails_path, svg_file_name), icon)
    end
  end
end
