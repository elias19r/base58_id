# Base58Id

Convert an Integer ID or a UUID String to/from Base58 String

## Install

Install it from rubygems.org in your terminal:

```sh
gem install base58_id
```

Or via `Gemfile` in your project:

```sh
source 'https://rubygems.org'

gem 'base58_id', '~> 1.0'
```

Or build and install the gem locally:

```sh
gem build base58_id.gemspec
gem install base58_id-1.0.0.gem
```

Require it in your Ruby code and the `Base58Id` class will be available:

```rb
require 'base58_id'
```

## Alphabet

It is based on Base64 URL-safe alphabet but with `I`, `O`, `l`, `0`, `-`, `_` removed:

```
A B C D E F G H   J K L M N   P Q R S T U V W X Y Z
a b c d e f g h i j k   m n o p q r s t u v w x y z
  1 2 3 4 5 6 7 8 9
```

## Example

```rb
require 'base58_id'

Base58Id.uuid_to_base58('058917af-0d2e-4755-b0bd-25b02b249824')
# => "qocqGYw9LEfu4WVujMzJv"

Base58Id.base58_to_uuid('qocqGYw9LEfu4WVujMzJv')
# => "058917af-0d2e-4755-b0bd-25b02b249824"

Base58Id.uuid_to_integer('058917af-0d2e-4755-b0bd-25b02b249824')
# => 7357965012972427318415208560898381860

Base58Id.integer_to_uuid(7357965012972427318415208560898381860)
# => "058917af-0d2e-4755-b0bd-25b02b249824"

Base58Id.base58_to_integer('qocqGYw9LEfu4WVujMzJv')
# => 7357965012972427318415208560898381860

Base58Id.integer_to_base58(7357965012972427318415208560898381860)
# => "qocqGYw9LEfu4WVujMzJv"

Base58Id.valid_base58?('qocqGYw9LEfu4WVujMzJv')
# => true

Base58Id.valid_base58?('IOl0-_')
# => false

# It accepts UUID String in many formats:
[
  '058917af0d2e4755b0bd25b02b249824',
  '058917AF0D2E4755B0BD25B02B249824',
  '0x058917af0d2e4755b0bd25b02b249824',
].map { |uuid| Base58Id.valid_uuid?(uuid) }
# => [true, true, true]

Base58Id::UUID_PATTERN
# => /\A(0x)?[0-9a-f]{8}-?[0-9a-f]{4}-?[0-9a-f]{4}-?[0-9a-f]{4}-?[0-9a-f]{12}\z/i
```

### Note

As it performs an integer conversion, Base58 leading zeros (represented by `A`)
are ignored/lost:

```rb
Base58Id.base58_to_integer('A') == Base58Id.base58_to_integer('AAAAAA')
# => true

Base58Id.base58_to_integer('AAAAAAqocqGYw9LEfu4WVujMzJv') ==
Base58Id.base58_to_integer('qocqGYw9LEfu4WVujMzJv')
# => true

Base58Id.integer_to_base58(Base58Id.base58_to_integer('AAAAAAqocqGYw9LEfu4WVujMzJv'))
# => "qocqGYw9LEfu4WVujMzJv"
```

And an empty Base58 String also represents zero:

```rb
Base58Id.base58_to_integer('')
# => 0

Base58Id.base58_to_uuid('')
# => "00000000-0000-0000-0000-000000000000"

Base58Id.base58_to_integer('') == Base58Id.base58_to_integer('A')
# => true
```

## Tests

Run tests with:

```sh
bundle exec rspec
```

## Linter

Check your code with:

```sh
bundle exec rubocop
```
