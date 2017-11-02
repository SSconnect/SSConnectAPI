# == Schema Information
#
# Table name: blogs
#
#  id         :integer          not null, primary key
#  title      :string
#  url        :string
#  rss        :string
#  selector   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Blog do

  describe '#destroy' do
    before do
      blogM = create(:blog_mode_ss)
      @blogY = create(:blog_yryr)

      @story =create(:story, :title => 'titleA')
      tags = %w(tagA tagB tagC)
      @story.regist_tags(tags)
      @a1 = create(:article, :story => @story, :blog => @blogY)

      @storyB =create(:story, :title => 'titleB')
      tags = %w(tagA tagB tagC)
      @storyB.regist_tags(tags)
      @a2 = create(:article, :story => @storyB, :blog => @blogY)
      @a3 = create(:article, :story => @storyB, :blog => blogM)

      # Bomb!
      @blogY.destroy()
    end

    it 'ブログ削除が正常に行われた' do
      expect(@blogY.destroyed?).to be_truthy
    end

    it 'ひもづく Articles が消えている' do
      expect(Article.where(id: @a1.id)).not_to exist
      expect(Article.where(id: @a2.id)).not_to exist
      expect(Article.where(id: @a3.id)).to exist
    end

    it '消えるべき Story だけ消えている' do
      expect(Story.where(id: @story.id)).not_to exist
      expect(Story.where(id: @storyB.id)).to exist
    end
  end
end
