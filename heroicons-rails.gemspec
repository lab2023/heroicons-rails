require_relative "lib/heroicons/version"

Gem::Specification.new do |spec|
  spec.name        = "heroicons-rails"
  spec.version     = Heroicons::VERSION
  spec.authors       = [ "lab2023" ]
  spec.email         = [ "info@lab2023.com" ]
  spec.homepage    = "https://github.com/lab2023/heroicons-rails"
  spec.summary     = "Icons component for Heroicons"
  spec.description = "Icons component for heroicons-v2.1.1"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "Set to "http://mygemserver.com""

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/lab2023/heroicons-rails"
  # spec.metadata["changelog_uri"] = "https://example.com"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end
end
