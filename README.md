# Abbey

A primitive JSON data store

## Description

A simple persistence library with human-readable representation. Uses good 'ol filesystem. Features: basic operations & namespaces. To be used for prototyping and as a backend of more sophisticated/specific implementations.

# Plans for the future (August 2014)

I hacked the original version together in several hours back when I was in high school. I needed such library for a freelance project I was working on back then and I decided to put it on GitHub because "why the hell not, lets see what happens".

It served the project that originally initiated its development well for more than two years. But unfortunately, there hasn't been much development going on once I had finished the initial version, therefore I had no reason to update and extend Abbey (v.i.).

Looking at the code, I realize how obsolete, inadequately implemented, and even poorly designed Abbey is. In the early days, I occasionally felt an urge to make Abbey better, or at least keep it up to date. I have also, however, come to realize that **developing libraries without using them is like tailoring a shirt without taking the measurements -- that is, vain and most likely useless.** It seems to me that that some of the worst interfaces have been designed "for other people to use". As you can imagine, investing my time into development of bad libraries was the last thing I wanted to do.

Now, after over two years since the last commit, I have a need for a similar library, although more sophisticated. **When I finish exploring existing gems, I'll either officially declare Abbey dead, or start working on a major overhaul, probably starting from scratch**

Pavel

## Usage

Warning: Abbey intentionally uses JSON, therefore it inherits it's caveats. Most notably, symbols are serialized to strings.

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

abbey.settings.logger # => #<Logger....>
```

## License

MIT. See LICENSE.txt

## Author

Pavel Kalvoda <me@pavelkalvoda.com>