require_relative "heroicons/version"
require_relative "heroicons/engine"
require_relative "heroicons/errors"
require_relative "heroicons/icon_scanner"
require_relative "heroicons/icon_syncer"

module Heroicons
  def self.root
    File.dirname(__dir__)
  end
end
