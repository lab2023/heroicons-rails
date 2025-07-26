require_relative "heroicons/version"
require_relative "heroicons/engine"
require_relative "heroicons/errors"

module Heroicons
  def self.root
    File.dirname(__dir__)
  end
end
