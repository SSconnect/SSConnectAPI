class Bracket < ApplicationRecord
  validates :title, presence: true

  def self.br
    br = '【' + self + '】'
    br
  end

end
