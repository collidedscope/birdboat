require "birdboat/core_ext/hash"

module Birdboat
  enum Mapping
    BEFR   # big-endian file+rank
    BERF   # big-endian rank+file
    LEFR   # little-endian file+rank
    LERF   # little-endian rank+file
    BEFLER # big-endian file, little-endian rank
    BERLEF # big-endian rank, little-endian file
    LEFBER # little-endian file, big-endian rank
    LERBEF # little-endian rank, big-endian file
  end

  {% begin %}
    alias Squares = Tuple({% for i in 0..63 %} Int32, {% end %})
  {% end %}

  def self.map
    Squares.from Array.new(64) { |i| yield i }
  end

  BERLEF_TO = {
    Mapping::BERLEF => map &.itself,
    Mapping::BERF   => map &.^(7),
    Mapping::LERF   => map &.^(56),
    Mapping::LERBEF => map &.^(63),
    Mapping::BEFLER => map { |i| i >> 3 | i << 3 & 63 },
    Mapping::LEFR   => map { |i| i >> 3 | i << 3 & 63 ^ 7 },
    Mapping::BEFR   => map { |i| i >> 3 | i << 3 & 63 ^ 56 },
    Mapping::LEFBER => map { |i| i >> 3 | i << 3 & 63 ^ 63 },
  }

  BERLEF_FROM = BERLEF_TO.dup
  BERLEF_FROM.swap Mapping::LEFR, Mapping::BEFR

  class Bitboard
    {% for mapping in Mapping.constants %}
      def to_{{mapping.downcase}}
        bits = @mapping.berlef? ? @bits : canonicalize @bits
        Bitboard.from_bools bits.values_at *BERLEF_TO[Mapping::{{mapping}}]
      end
    {% end %}

    private def canonicalize(bits)
      bits.values_at *BERLEF_FROM[@mapping]
    end
  end
end
