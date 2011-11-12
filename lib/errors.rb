module Abbey

  # Thrown when trying to overwrite an item
  class ItemAlreadyPresentError < RuntimeError
  end

  class ItemNotFoundError < RuntimeError
  end
end