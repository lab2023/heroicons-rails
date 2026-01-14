# frozen_string_literal: true

require_relative "heroicons/version"
require_relative "heroicons/engine"
require_relative "heroicons/errors"
require_relative "heroicons/configuration"

module Heroicons
  class << self
    def root
      File.dirname(__dir__)
    end

    def configuration
      Configuration.instance
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      Configuration.reset!
    end
  end
end
