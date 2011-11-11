# Abbey

A primitive JSON data store

## Description

A simple persistence library with human-readable representation. Uses good 'ol filesystem. Features: basic operations & namespaces. To be used for prototyping and as a backend of more sophisticated/specific implementations.

## Usage

Warning: Abbey intentionally uses JSON, therefore it inherits its' caveats. Most notably, symbols are serialized to strings.

```ruby
require 'abbey'

abbey = Abbey::EntityStorage.new(Abbey::Settings.new('/var/myapp/data', [:users, :books]))

abbey.set_up! unless abbey.set_up? # will prepare directories and shit

abbey.save(:users, :admin, {:name => "John Smith"})

abbey.save(:users, :admin, {:name => "John Smith"}) # => Abbey::ItemAlreadyExistsError

abbey.get(:users, :admin) # => {"name" => "John Smith"}

abbey.update(:users, :admin, {:name => "John C. Smith"})

abbey.update(:users, :nonexistent, {:name => "Joe Black"}) # => Abbey::ItemNotFoundError

abbey.list(:users) # => #<Set: {:admin}>

abbey.get_all(:users) # => {"admin" => {"name" => "John Smith"}}

abbey.delete(:users, :admin)

abbey.drop(:users) # will delete all data in the namespace

abbey.exists?(:users, :admin) # => false

abbey.settings.namespaces # => [:users, :books]

abbey.settings.logger # => #<Loger....>
```

## License

MIT. See LICENSE.txt

## Author

Pavel Kalvoda <me@pavelkalvoda.com>