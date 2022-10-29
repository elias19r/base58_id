# frozen_string_literal: true

require 'spec_helper'
require 'base58_id'

RSpec.describe Base58Id do
  it 'converts Integer ID or UUID String to/from Base58 String' do
    base58 = generate_base58

    expect(
      described_class.integer_to_base58(
        described_class.base58_to_integer(base58)
      )
    ).to eq(base58)

    expect(
      described_class.uuid_to_base58(
        described_class.base58_to_uuid(base58)
      )
    ).to eq(base58)

    base58_with_leading_zeros = "AAAAAAAA#{base58}"

    expect(
      described_class.integer_to_base58(
        described_class.base58_to_integer(base58_with_leading_zeros)
      )
    ).to eq(base58)

    expect(
      described_class.uuid_to_base58(
        described_class.base58_to_uuid(base58_with_leading_zeros)
      )
    ).to eq(base58)

    base58_empty = ''

    expect(
      described_class.integer_to_base58(
        described_class.base58_to_integer(base58_empty)
      )
    ).to eq('A')

    expect(
      described_class.uuid_to_base58(
        described_class.base58_to_uuid(base58_empty)
      )
    ).to eq('A')

    integer = generate_non_negative_integer

    expect(
      described_class.base58_to_integer(
        described_class.integer_to_base58(integer)
      )
    ).to eq(integer)

    expect(
      described_class.uuid_to_integer(
        described_class.integer_to_uuid(integer)
      )
    ).to eq(integer)

    uuid = generate_uuid

    expect(
      described_class.base58_to_uuid(
        described_class.uuid_to_base58(uuid)
      )
    ).to eq(uuid)

    expect(
      described_class.integer_to_uuid(
        described_class.uuid_to_integer(uuid)
      )
    ).to eq(uuid)
  end

  describe '.integer_to_base58' do
    context 'when argument is not an Integer' do
      it 'raises an ArgumentError' do
        non_integer = Object.new

        expect do
          described_class.integer_to_base58(non_integer)
        end.to raise_error(ArgumentError, 'argument must be an Integer')
      end
    end

    context 'when argument is an Integer but negative' do
      it 'raises an ArgumentError' do
        negative_integer = generate_negative_integer

        expect do
          described_class.integer_to_base58(negative_integer)
        end.to raise_error(ArgumentError, 'argument must be greater than or equal to zero')
      end
    end

    context 'when argument is a non-negative Integer' do
      it 'formats unsigned integer as Base58 String' do
        integer = generate_non_negative_integer

        expect(described_class.integer_to_base58(integer).count("^#{base58_chars.join}")).to eq(0)

        some_test_cases.each do |test_case|
          expect(described_class.integer_to_base58(test_case[:integer])).to eq(test_case[:base58])
        end
      end
    end
  end

  describe '.base58_to_integer' do
    context 'when value is not a valid Base58 String' do
      it 'raises an ArgumentError' do
        non_string = Object.new

        expect do
          described_class.base58_to_integer(non_string)
        end.to raise_error(ArgumentError, 'argument must be a String')

        non_base58_chars.each do |non_base58|
          expect do
            described_class.base58_to_integer(non_base58)
          end.to raise_error(ArgumentError, 'argument must be a valid Base58 String')
        end
      end
    end

    context 'when value is a valid Base58 String' do
      it 'returns the corresponding Integer' do
        big_base58 = generate_big_base58

        expect(described_class.base58_to_integer(big_base58)).to be_an(Integer)

        base58_empty = ''

        expect(described_class.base58_to_integer(base58_empty)).to eq(0)

        some_test_cases.each do |test_case|
          expect(described_class.base58_to_integer(test_case[:base58])).to eq(test_case[:integer])
        end
      end
    end
  end

  describe '.uuid_to_base58' do
    context 'when argument is not a valid UUID String' do
      it 'raises an ArgumentError' do
        non_string = Object.new

        expect do
          described_class.uuid_to_base58(non_string)
        end.to raise_error(ArgumentError, 'argument must be a String')

        non_uuid = '123'

        expect do
          described_class.uuid_to_base58(non_uuid)
        end.to raise_error(ArgumentError, 'argument must be a valid UUID String')
      end
    end

    context 'when argument is a valid UUID String' do
      it 'returns the corresponding Base58' do
        uuid = generate_uuid

        expect(described_class.uuid_to_base58(uuid).count("^#{base58_chars.join}")).to eq(0)

        some_test_cases.each do |test_case|
          expect(described_class.uuid_to_base58(test_case[:uuid])).to eq(test_case[:base58])
        end
      end
    end
  end

  describe '.base58_to_uuid' do
    context 'when value is not a valid Base58 String' do
      it 'raises an ArgumentError' do
        non_string = Object.new

        expect do
          described_class.base58_to_uuid(non_string)
        end.to raise_error(ArgumentError, 'argument must be a String')

        non_base58_chars.each do |non_base58|
          expect do
            described_class.base58_to_uuid(non_base58)
          end.to raise_error(ArgumentError, 'argument must be a valid Base58 String')
        end
      end
    end

    context 'when value is a valid Base58 String but numeric value requires more than 16 bytes' do
      it 'raises an ArgumentError' do
        big_base58 = generate_big_base58

        expect do
          described_class.base58_to_uuid(big_base58)
        end.to raise_error(ArgumentError, 'argument size must not require more than 16 bytes')
      end
    end

    context 'when value is a valid Base58 String and numeric value does not require more than 16 bytes' do
      it 'returns the corresponding UUID String' do
        base58 = generate_base58

        expect(described_class.base58_to_uuid(base58))
          .to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/)

        base58_empty = ''

        expect(described_class.base58_to_uuid(base58_empty)).to eq('00000000-0000-0000-0000-000000000000')

        some_test_cases.each do |test_case|
          expect(described_class.base58_to_uuid(test_case[:base58])).to eq(test_case[:uuid])
        end
      end
    end
  end

  describe '.uuid_to_integer' do
    context 'when argument is not a valid UUID String' do
      it 'raises an ArgumentError' do
        non_string = Object.new

        expect do
          described_class.uuid_to_integer(non_string)
        end.to raise_error(ArgumentError, 'argument must be a String')

        non_uuid = '123'

        expect do
          described_class.uuid_to_integer(non_uuid)
        end.to raise_error(ArgumentError, 'argument must be a valid UUID String')
      end
    end

    context 'when argument is a valid UUID String' do
      it 'returns the corresponding Integer' do
        uuid = generate_uuid

        expect(described_class.uuid_to_integer(uuid)).to be_an(Integer)

        some_test_cases.each do |test_case|
          expect(described_class.uuid_to_integer(test_case[:uuid])).to eq(test_case[:integer])
        end
      end
    end
  end

  describe '.integer_to_uuid' do
    context 'when argument is not an Integer' do
      it 'raises an ArgumentError' do
        non_integer = Object.new

        expect do
          described_class.integer_to_uuid(non_integer)
        end.to raise_error(ArgumentError, 'argument must be an Integer')
      end
    end

    context 'when argument is an Integer but negative' do
      it 'raises an ArgumentError' do
        negative_integer = generate_negative_integer

        expect do
          described_class.integer_to_uuid(negative_integer)
        end.to raise_error(ArgumentError, 'argument must be greater than or equal to zero')
      end
    end

    context 'when argument is a non-negative Integer but requires more than 16 bytes' do
      it 'raises an ArgumentError' do
        big_integer = generate_big_integer

        expect do
          described_class.integer_to_uuid(big_integer)
        end.to raise_error(ArgumentError, 'argument size must not require more than 16 bytes')
      end
    end

    context 'when argument is a non-negative Integer and does not require more than 16 bytes' do
      it 'formats 128-bit unsigned integer as UUID String' do
        uuid = generate_uuid
        integer = uuid.delete('-').to_i(16)

        expect(described_class.integer_to_uuid(integer)).to eq(uuid)

        some_test_cases.each do |test_case|
          expect(described_class.integer_to_uuid(test_case[:integer])).to eq(test_case[:uuid])
        end
      end
    end
  end

  describe '.valid_base58?' do
    context 'when value is not a String' do
      it 'raises an ArgumentError' do
        value = Object.new

        expect do
          described_class.valid_base58?(value)
        end.to raise_error(ArgumentError, 'argument must be a String')
      end
    end

    context 'when value is a String but contains chars not present in the Base58 alphabet' do
      it 'returns false' do
        non_base58_chars.each do |value|
          expect(described_class.valid_base58?(value)).to be(false)
        end
      end
    end

    context 'when value is a String and contains only chars present in the Base58 alphabet' do
      it 'returns true' do
        base58_chars.each do |value|
          expect(described_class.valid_base58?(value)).to be(true)
        end

        value = ''

        expect(described_class.valid_base58?(value)).to be(true)

        value = generate_big_base58

        expect(described_class.valid_base58?(value)).to be(true)
      end
    end
  end

  describe '.valid_uuid?' do
    context 'when value is not a String' do
      it 'raises an ArgumentError' do
        value = Object.new

        expect do
          described_class.valid_uuid?(value)
        end.to raise_error(ArgumentError, 'argument must be a String')
      end
    end

    context 'when value is a String but does not match the UUID pattern' do
      it 'returns false' do
        value = '123'

        expect(described_class.valid_uuid?(value)).to be(false)
      end
    end

    context 'when value is a String and matches the UUID pattern' do
      it 'returns true' do
        value = generate_uuid

        expect(described_class.valid_uuid?(value)).to be(true)
        expect(described_class.valid_uuid?(value.delete('-'))).to be(true)
        expect(described_class.valid_uuid?("0x#{value.delete('-')}")).to be(true)
        expect(described_class.valid_uuid?("0X#{value.delete('-')}")).to be(true)

        expect(described_class.valid_uuid?(value.upcase)).to be(true)
        expect(described_class.valid_uuid?(value.upcase.delete('-'))).to be(true)
        expect(described_class.valid_uuid?("0x#{value.upcase.delete('-')}")).to be(true)
        expect(described_class.valid_uuid?("0X#{value.upcase.delete('-')}")).to be(true)
      end
    end
  end

  describe '.random_number' do
    context 'when max_or_range is not set or nil' do
      it 'generates a random Base58 String using the default range' do
        expected_default_random_range = 0..((2**63) - 1)

        allow(SecureRandom).to receive(:random_number).with(expected_default_random_range).and_return(1000)

        expect(described_class.random_number).to eq('TQ')
        expect(described_class.random_number(nil)).to eq('TQ')

        expect(SecureRandom).to have_received(:random_number).with(expected_default_random_range).twice
      end
    end

    context 'when max_or_range is set and not nil' do
      it 'generates a random Base58 String using the given range' do
        max_or_range = 100

        allow(SecureRandom).to receive(:random_number).and_return(99)

        expect(described_class.random_number(max_or_range)).to eq('Bs')

        expect(SecureRandom).to have_received(:random_number).with(max_or_range).once
      end
    end
  end

  describe '.rand as an alias to random_number' do
    context 'when max_or_range is not set or nil' do
      it 'generates a random Base58 String using the default range' do
        expected_default_random_range = 0..((2**63) - 1)

        allow(SecureRandom).to receive(:random_number).with(expected_default_random_range).and_return(1000)

        expect(described_class.rand).to eq('TQ')
        expect(described_class.rand(nil)).to eq('TQ')

        expect(SecureRandom).to have_received(:random_number).with(expected_default_random_range).twice
      end
    end

    context 'when max_or_range is set and not nil' do
      it 'generates a random Base58 String using the given range' do
        max_or_range = 100

        allow(SecureRandom).to receive(:random_number).and_return(99)

        expect(described_class.rand(max_or_range)).to eq('Bs')

        expect(SecureRandom).to have_received(:random_number).with(max_or_range).once
      end
    end
  end

  describe '.random_digits' do
    context 'when n is set to non-nil but not an Integer' do
      it 'raises an ArgumentError' do
        non_integer = Object.new

        expect do
          described_class.random_digits(non_integer)
        end.to raise_error(ArgumentError, 'argument must be an Integer')
      end
    end

    context 'when n is not set or nil' do
      it 'generates a random string of 10 Base58 digits' do
        string = described_class.random_digits

        expect(string.size).to eq(10)
        expect(string.count("^#{base58_chars.join}")).to eq(0)

        string = described_class.random_digits(nil)

        expect(string.size).to eq(10)
        expect(string.count("^#{base58_chars.join}")).to eq(0)
      end
    end

    context 'when n is zero or a negative Integer' do
      it 'returns an empty string' do
        string = described_class.random_digits(0)

        expect(string).to eq('')

        string = described_class.random_digits(generate_negative_integer)

        expect(string).to eq('')
      end
    end

    context 'when n is a positive Integer' do
      it 'generates a random string of n Base58 digits' do
        n = SecureRandom.random_number(1..256)
        string = described_class.random_digits(n)

        expect(string.size).to eq(n)
        expect(string.count("^#{base58_chars.join}")).to eq(0)
      end
    end
  end

  def generate_uuid
    SecureRandom.uuid
  end

  def generate_negative_integer
    rand((-2**63)..-1)
  end

  def generate_non_negative_integer
    rand(0..((2**63) - 1))
  end

  def generate_big_integer
    rand((2**128)..(2**144))
  end

  def generate_base58
    generate_non_zero_base58_digit + base58_chars.sample(19).join
  end

  def generate_big_base58
    generate_non_zero_base58_digit + base58_chars.sample(24).join
  end

  def generate_non_zero_base58_digit
    base58_chars[1..].sample
  end

  let(:base58_chars) do
    %w[
      A B C D E F G H   J K L M N   P Q R S T U V W X Y Z
      a b c d e f g h i j k   m n o p q r s t u v w x y z
        1 2 3 4 5 6 7 8 9
    ]
  end

  let(:non_base58_chars) do
    (' '..'~').to_a - base58_chars
  end

  let(:some_test_cases) do
    [
      { integer: 0,  base58: 'A',  uuid: '00000000-0000-0000-0000-000000000000' },
      { integer: 1,  base58: 'B',  uuid: '00000000-0000-0000-0000-000000000001' },
      { integer: 2,  base58: 'C',  uuid: '00000000-0000-0000-0000-000000000002' },
      { integer: 3,  base58: 'D',  uuid: '00000000-0000-0000-0000-000000000003' },
      { integer: 4,  base58: 'E',  uuid: '00000000-0000-0000-0000-000000000004' },
      { integer: 5,  base58: 'F',  uuid: '00000000-0000-0000-0000-000000000005' },
      { integer: 6,  base58: 'G',  uuid: '00000000-0000-0000-0000-000000000006' },
      { integer: 7,  base58: 'H',  uuid: '00000000-0000-0000-0000-000000000007' },
      { integer: 8,  base58: 'J',  uuid: '00000000-0000-0000-0000-000000000008' },
      { integer: 9,  base58: 'K',  uuid: '00000000-0000-0000-0000-000000000009' },
      { integer: 10, base58: 'L',  uuid: '00000000-0000-0000-0000-00000000000a' },
      { integer: 11, base58: 'M',  uuid: '00000000-0000-0000-0000-00000000000b' },
      { integer: 12, base58: 'N',  uuid: '00000000-0000-0000-0000-00000000000c' },
      { integer: 13, base58: 'P',  uuid: '00000000-0000-0000-0000-00000000000d' },
      { integer: 14, base58: 'Q',  uuid: '00000000-0000-0000-0000-00000000000e' },
      { integer: 15, base58: 'R',  uuid: '00000000-0000-0000-0000-00000000000f' },
      { integer: 16, base58: 'S',  uuid: '00000000-0000-0000-0000-000000000010' },
      { integer: 17, base58: 'T',  uuid: '00000000-0000-0000-0000-000000000011' },
      { integer: 18, base58: 'U',  uuid: '00000000-0000-0000-0000-000000000012' },
      { integer: 19, base58: 'V',  uuid: '00000000-0000-0000-0000-000000000013' },
      { integer: 20, base58: 'W',  uuid: '00000000-0000-0000-0000-000000000014' },
      { integer: 21, base58: 'X',  uuid: '00000000-0000-0000-0000-000000000015' },
      { integer: 22, base58: 'Y',  uuid: '00000000-0000-0000-0000-000000000016' },
      { integer: 23, base58: 'Z',  uuid: '00000000-0000-0000-0000-000000000017' },
      { integer: 24, base58: 'a',  uuid: '00000000-0000-0000-0000-000000000018' },
      { integer: 25, base58: 'b',  uuid: '00000000-0000-0000-0000-000000000019' },
      { integer: 26, base58: 'c',  uuid: '00000000-0000-0000-0000-00000000001a' },
      { integer: 27, base58: 'd',  uuid: '00000000-0000-0000-0000-00000000001b' },
      { integer: 28, base58: 'e',  uuid: '00000000-0000-0000-0000-00000000001c' },
      { integer: 29, base58: 'f',  uuid: '00000000-0000-0000-0000-00000000001d' },
      { integer: 30, base58: 'g',  uuid: '00000000-0000-0000-0000-00000000001e' },
      { integer: 31, base58: 'h',  uuid: '00000000-0000-0000-0000-00000000001f' },
      { integer: 32, base58: 'i',  uuid: '00000000-0000-0000-0000-000000000020' },
      { integer: 33, base58: 'j',  uuid: '00000000-0000-0000-0000-000000000021' },
      { integer: 34, base58: 'k',  uuid: '00000000-0000-0000-0000-000000000022' },
      { integer: 35, base58: 'm',  uuid: '00000000-0000-0000-0000-000000000023' },
      { integer: 36, base58: 'n',  uuid: '00000000-0000-0000-0000-000000000024' },
      { integer: 37, base58: 'o',  uuid: '00000000-0000-0000-0000-000000000025' },
      { integer: 38, base58: 'p',  uuid: '00000000-0000-0000-0000-000000000026' },
      { integer: 39, base58: 'q',  uuid: '00000000-0000-0000-0000-000000000027' },
      { integer: 40, base58: 'r',  uuid: '00000000-0000-0000-0000-000000000028' },
      { integer: 41, base58: 's',  uuid: '00000000-0000-0000-0000-000000000029' },
      { integer: 42, base58: 't',  uuid: '00000000-0000-0000-0000-00000000002a' },
      { integer: 43, base58: 'u',  uuid: '00000000-0000-0000-0000-00000000002b' },
      { integer: 44, base58: 'v',  uuid: '00000000-0000-0000-0000-00000000002c' },
      { integer: 45, base58: 'w',  uuid: '00000000-0000-0000-0000-00000000002d' },
      { integer: 46, base58: 'x',  uuid: '00000000-0000-0000-0000-00000000002e' },
      { integer: 47, base58: 'y',  uuid: '00000000-0000-0000-0000-00000000002f' },
      { integer: 48, base58: 'z',  uuid: '00000000-0000-0000-0000-000000000030' },
      { integer: 49, base58: '1',  uuid: '00000000-0000-0000-0000-000000000031' },
      { integer: 50, base58: '2',  uuid: '00000000-0000-0000-0000-000000000032' },
      { integer: 51, base58: '3',  uuid: '00000000-0000-0000-0000-000000000033' },
      { integer: 52, base58: '4',  uuid: '00000000-0000-0000-0000-000000000034' },
      { integer: 53, base58: '5',  uuid: '00000000-0000-0000-0000-000000000035' },
      { integer: 54, base58: '6',  uuid: '00000000-0000-0000-0000-000000000036' },
      { integer: 55, base58: '7',  uuid: '00000000-0000-0000-0000-000000000037' },
      { integer: 56, base58: '8',  uuid: '00000000-0000-0000-0000-000000000038' },
      { integer: 57, base58: '9',  uuid: '00000000-0000-0000-0000-000000000039' },
      { integer: 58, base58: 'BA', uuid: '00000000-0000-0000-0000-00000000003a' },

      { integer: 58 * 2,  base58: 'CA',  uuid: '00000000-0000-0000-0000-000000000074' },
      { integer: 58 * 3,  base58: 'DA',  uuid: '00000000-0000-0000-0000-0000000000ae' },
      { integer: 58 * 10, base58: 'LA',  uuid: '00000000-0000-0000-0000-000000000244' },
      { integer: 58 * 20, base58: 'WA',  uuid: '00000000-0000-0000-0000-000000000488' },
      { integer: 58 * 58, base58: 'BAA', uuid: '00000000-0000-0000-0000-000000000d24' },

      { integer: 231, base58: 'D9', uuid: '00000000-0000-0000-0000-0000000000e7' },
      { integer: 232, base58: 'EA', uuid: '00000000-0000-0000-0000-0000000000e8' },
      { integer: 255, base58: 'EZ', uuid: '00000000-0000-0000-0000-0000000000ff' },
      { integer: 256, base58: 'Ea', uuid: '00000000-0000-0000-0000-000000000100' },
      { integer: 280, base58: 'Ez', uuid: '00000000-0000-0000-0000-000000000118' },
      { integer: 281, base58: 'E1', uuid: '00000000-0000-0000-0000-000000000119' },
      { integer: 289, base58: 'E9', uuid: '00000000-0000-0000-0000-000000000121' },
      { integer: 290, base58: 'FA', uuid: '00000000-0000-0000-0000-000000000122' },

      { integer: (58**10) - 1, base58: '9999999999',            uuid: '00000000-0000-0000-05fa-8624c7fba3ff' },
      { integer: 58**10,       base58: 'BAAAAAAAAAA',           uuid: '00000000-0000-0000-05fa-8624c7fba400' },
      { integer: 58**20,       base58: 'BAAAAAAAAAAAAAAAAAAAA', uuid: '0023be67-b5f0-f288-9aaf-505301100000' },

      { integer: (2**128) - 2, base58: 'hmep7uZkFTa9zuEuQB3XV4', uuid: 'ffffffff-ffff-ffff-ffff-fffffffffffe' },
      { integer: (2**128) - 1, base58: 'hmep7uZkFTa9zuEuQB3XV5', uuid: 'ffffffff-ffff-ffff-ffff-ffffffffffff' },
    ]
  end
end
