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

  describe '#patch_delete_all' do
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
      @blogY.patch_delete_all()
    end

    it 'ブログ削除が正常に行われた' do
      expect(@blogY).to be_nil
    end

    it 'ひもづく Articles が消えている' do
      expect(@a1).to be_nil
      expect(@a2).to be_nil
      expect(@a3).not_to be_nil
    end

    it '消えるべき Story だけ消えている' do
      expect(@story).to be_nil
      expect(@storyB).not_to be_nil
    end
  end
end
