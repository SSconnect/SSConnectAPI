class Swing < ApplicationRecord
  validates :wrong,:correct, presence: true, uniqueness: true
  after_create do
    Story.tag_list.remove(self.wrong)
    Story.tag_list << self.current
  end
end
