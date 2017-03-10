# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Story < ApplicationRecord
  validates :title, presence: true
  has_many :articles
  acts_as_taggable
end
