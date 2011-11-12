module Abbey

  # Represents the store. Manages the data for you.
  # JSON serialization under the hood.
  class EntityStorage

    # @return [Settings]
    attr_accessor :settings

    # @param settings [Settings]
    def initialize(settings)
      @settings = settings
    end

    # Is everything ready?
    # @return void
    def set_up?
      ready = true
      dirs = [settings.path]
      settings.namespaces.each {|x| dirs << make_path(x)}
      dirs.each do |dir|
        existent, writable = Dir.exists?(dir), File.writable?(dir)
        settings.logger.debug("#{dir} -- exists: #{existent}, writable: #{writable}")
        ready &&= existent && writable
      end
      ready
    end

    # Set up the directory structure
    # @return void
    def set_up!
      settings.namespaces.each do |ns|
        path = make_path(ns)
        if !Dir.exists?(path) then
          settings.logger.debug("Creating dir #{path}")
          FileUtils.mkdir_p(path)
        end
      end
    end

    # Save an item
    # @param namespace [String, Fixnum, Symbol or any other object whose #to_s method returns string]
    # @param key [String, Fixnum, Symbol or any other object whose #to_s method returns string]
    # @param data [Object]
    # @return void
    def save(namespace, key, data)
      path = make_path(namespace, key)
      raise ItemAlreadyPresentError.new if File.exist?(path)
      f = File.new(path, File::CREAT | File::RDWR)
      size = f.write(MultiJson.encode(data))
      f.close
      settings.logger.info("Written #{make_key(namespace, key)} (size: #{size})")
    end

    # Fetch an item
    # @param namespace [String, Fixnum, Symbol or any other object whose #to_s method returns string]
    # @param key [String, Fixnum, Symbol or any other object whose #to_s method returns string]
    # @return [Object]
    def get(namespace, key)
      path = make_path(namespace, key)
      raise ItemNotFoundError.new unless exists?(namespace, key)
      settings.logger.info("Read #{make_key(namespace, key)}")
      MultiJson.decode(File.read(path))
    end

    # Does the item exist?
    # @param namespace [String, Fixnum, Symbol or any other object whose #to_s method returns string]
    # @param key [String, Fixnum, Symbol or any other object whose #to_s method returns string]
    # @return [Boolean]
    def exists?(namespace, key)
      exists = File.exist?(make_path(namespace, key))
      settings.logger.info("Queried #{make_key(namespace, key)}, found: #{exists}")
      exists
    end

    # Update an item. Shorthand for delete & save
    # @param namespace [String, Fixnum, Symbol or any other object whose #to_s method returns string]
    # @param key [String, Fixnum, Symbol or any other object whose #to_s method returns string]
    # @param data [Object]
    # @return void
    def update(namespace, key, data)
      delete(namespace, key)
      save(namespace, key, data)
    end

    # Delete an item
    # @param namespace [String, Fixnum, Symbol or any other object whose #to_s method returns string]
    # @param key [String, Fixnum, Symbol or any other object whose #to_s method returns string]
    # @return void
    def delete(namespace, key)
      path = make_path(namespace, key)
      raise ItemNotFoundError.new unless exists?(namespace, key)
      File.delete(path)
      settings.logger.info("Deleted #{make_key(namespace,key)}")
    end

    # Get keys of all entries in the namespace
    # @param namespace [String, Fixnum, Symbol or any other object whose #to_s method returns string]
    # @return [Set] List of all keys in the namespace
    def list(namespace)
      list = Dir.entries(make_path(namespace)) - %w{. ..}
      list.map! {|item| File.split(item)[1].to_sym}
      list.to_set
    end

    # @param namespace [String, Fixnum, Symbol or any other object whose #to_s method returns string]
    # @return [Hash] Hash of all items in the namespace, indexed by items' keys
    def get_all(namespace)
      result = {}
      list(namespace).each {|key| result[key] = get(namespace, key)}
      result
    end

    private

    def make_path(namespace, key = nil)
      dir = File.join(settings.path, namespace.to_s)
      key ? File.join(dir, key.to_s) : dir
    end

    def make_key(namespace, key)
      namespace.to_s + ':' + key.to_s
    end
  end
end