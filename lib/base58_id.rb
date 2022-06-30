# frozen_string_literal: true

class Base58Id
  # Based on Base64 URL-safe alphabet but with I, O, l, 0, -, _ removed.
  ALPHABET_58 = %w[
    A B C D E F G H   J K L M N   P Q R S T U V W X Y Z
    a b c d e f g h i j k   m n o p q r s t u v w x y z
      1 2 3 4 5 6 7 8 9
  ].freeze

  ALPHABET_58_INVERT = ALPHABET_58.each_with_index.to_h
  ALPHABET_58_CHARS = ALPHABET_58.join
  CARET_ALPHABET_58_CHARS = "^#{ALPHABET_58_CHARS}"

  UUID_PATTERN = /\A(0x)?[0-9a-f]{8}-?[0-9a-f]{4}-?[0-9a-f]{4}-?[0-9a-f]{4}-?[0-9a-f]{12}\z/i.freeze
  UUID_BYTES_FORMAT = '%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x'

  def self.integer_to_base58(integer)
    raise ArgumentError, 'argument must be an Integer' unless integer.is_a?(Integer)
    raise ArgumentError, 'argument must be greater than or equal to zero' if integer.negative?

    integer.digits(58).reduce('') { |str, digit| ALPHABET_58[digit] + str }
  end

  def self.base58_to_integer(base58)
    raise ArgumentError, 'argument must be a valid Base58 String' unless valid_base58?(base58)

    base58.chars.reduce(0) { |integer, digit| (integer * 58) + ALPHABET_58_INVERT[digit] }
  end

  def self.uuid_to_base58(uuid)
    raise ArgumentError, 'argument must be a valid UUID String' unless valid_uuid?(uuid)

    integer_to_base58(uuid_to_integer(uuid))
  end

  def self.base58_to_uuid(base58)
    integer_to_uuid(base58_to_integer(base58))
  end

  def self.uuid_to_integer(uuid)
    raise ArgumentError, 'argument must be a valid UUID String' unless valid_uuid?(uuid)

    uuid.delete('-').to_i(16)
  end

  def self.integer_to_uuid(integer)
    raise ArgumentError, 'argument must be an Integer' unless integer.is_a?(Integer)
    raise ArgumentError, 'argument must be greater than or equal to zero' if integer.negative?

    bytes_array = integer.digits(256)

    raise ArgumentError, 'argument size must not require more than 16 bytes' if bytes_array.size > 16

    while bytes_array.size < 16
      bytes_array.push(0)
    end

    UUID_BYTES_FORMAT % bytes_array.reverse
  end

  def self.valid_base58?(value)
    raise ArgumentError, 'argument must be a String' unless value.is_a?(String)

    value.count(CARET_ALPHABET_58_CHARS).zero?
  end

  def self.valid_uuid?(value)
    raise ArgumentError, 'argument must be a String' unless value.is_a?(String)

    value.match?(UUID_PATTERN)
  end
end
