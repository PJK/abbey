require 'logger'

module Abbey
  class Settings
    attr_accessor :namespaces, :logger,  :path

    def initialize(path, namespaces = [], logger = nil)
      @path = path
      @namespaces = namespaces
      @logger = (logger || Logger.new('/dev/null'))
    end
  end
end