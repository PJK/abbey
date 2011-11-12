require 'logger'

module Abbey
  class Settings
    attr_accessor :namespaces, :logger,  :path

    # @param path [String] Filesystem path to store the data in
    # @param namespaces [Array] Namespaces to create
    # @param logger [Logger]
    def initialize(path, namespaces = [], logger = nil)
      @path = path
      @namespaces = namespaces
      @logger = (logger || Logger.new('/dev/null'))
    end
  end
end