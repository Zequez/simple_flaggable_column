# SimpleFlaggableColumn

Allows you to add really simple binary flag column to an ActiveRecord model.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_flaggable_column'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_flaggable_column

## Usage example

Migration:

```ruby
add_column(:games, :platforms, :integer, default: 0, null: false)
```

Model:

```ruby
class Game < ActiveRecord::Base
  include SimpleFlaggableColumn

  flag_column :platforms, {
    win:   0b001,
    mac:   0b010,
    linux: 0b100
  }
end
```

This redefines the `platforms` method in `Game` so you can set it and read it as an array:

```ruby
game = Game.new
game.platforms = [:win, :linux]
# => [:win, :linux]
game.read_attribute :platforms
# => 5
game.read_attribute(:platforms).to_s(2)
# => "101"
```

Push/Pop and other arrays operations won't work, just simple writing and reading.

## Contributing

1. Fork it ( https://github.com/Zequez/simple_flaggable_column/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
