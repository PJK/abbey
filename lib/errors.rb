module Abbey

  # Raised when trying to overwrite an item
  class ItemAlreadyPresentError < RuntimeError
  end

  class ItemNotFoundError < RuntimeError
  end

  # Raised when the data can't be serialized
  class NotSerializableError < ArgumentError
  end

  # Raised when a key or a namespace containing a FS separator is passed
  class InvalidNameError < ArgumentError
  end
end