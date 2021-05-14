require "bit_array"
require "birdboat/core_ext/bit_array"

class Birdboat::Bitboard
  property bits : BitArray

  def initialize(@bits, @mapping : Mapping = Mapping::BERLEF)
  end

  def to_hex(prefix = "0x", suffix = "u64")
    prefix + bits.to_slice.hexstring + suffix
  end

  def self.from_u64(n)
    new BitArray.new(64).tap { |ba|
      n.bit_length.times { |i| ba[i] = n.bit(i) == 1 }
    }
  end

  def self.from_bits(indices)
    new BitArray.new(64).tap { |ba|
      indices.each { |i| ba[i] = true }
    }
  end

  def self.from_bools(bools)
    raise "Need 64 values" if bools.size != 64
    new BitArray.new(64) { |i| bools[i] }
  end

  def self.from_ranges(*ranges)
    new BitArray.new(64).tap { |ba|
      ranges.each { |r| r.each { |i| ba[i] = true } }
    }
  end
end
