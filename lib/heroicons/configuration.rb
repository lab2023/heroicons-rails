module Heroicons
  class Configuration
    attr_accessor :default_type, :default_class

    def initialize
      @default_type = :outline
      @default_class = "w-6 h-6"
    end
  end
end
