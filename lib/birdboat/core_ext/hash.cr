class Hash(K, V)
  def swap(a, b)
    self[a], self[b] = self[b], self[a]
  end
end
