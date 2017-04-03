class String
  def has_emoji?
    self.each_char.select { |c| c.bytes.count >= 4 }.length > 0
  end
end