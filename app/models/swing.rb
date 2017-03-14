class Swing < ApplicationRecord
  validates :wrong,:correct, presence: true, uniqueness: true
  after_create do

  end
end
