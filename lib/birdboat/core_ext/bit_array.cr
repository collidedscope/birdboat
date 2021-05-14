struct BitArray
  def self.new(size)
    new(size).tap { |ba|
      size.times { |i| ba[i] = yield i }
    }
  end
end
