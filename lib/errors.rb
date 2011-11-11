module Abbey
  class ItemAlreadyPresentError < RuntimeError
  end

  class ItemNotFoundError < RuntimeError
  end
end