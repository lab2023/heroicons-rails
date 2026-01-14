module Heroicons
  class Configuration
    MUTEX = Mutex.new

    class << self
      def instance
        MUTEX.synchronize do
          @instance ||= new
        end
      end

      def reset!
        MUTEX.synchronize do
          @instance = new
        end
      end
    end

    attr_accessor :default_type, :default_class

    def initialize
      @default_type = :outline
      @default_class = "w-6 h-6"
    end
  end
end
