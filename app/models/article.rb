# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  url        :string
#  posted_at  :datetime
#  blog_id    :integer
#  story_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Article < ApplicationRecord
  belongs_to :blog, :foreign_key => :blog_id
  belongs_to :story, :foreign_key => :story_id

  def self.create_with_story(url, posted_at, blog, title, tag)
    story = Story.find_or_create_by(title: title)
    story.regist_tag(tag)
    story.articles.create(
        url: url,
        posted_at: posted_at,
        blog: blog
    )
  end

  after_create do
    if story.last_posted_at.nil? ||self.story.last_posted_at > self.posted_at
      self.story.last_posted_at = self.posted_at
    end
    story.save
  end
end
