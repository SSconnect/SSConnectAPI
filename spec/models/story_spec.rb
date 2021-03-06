# == Schema Information
#
# Table name: stories
#
#  id              :integer          not null, primary key
#  title           :string
#  first_posted_at :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

describe Story do
  describe '#regist_story' do
    it 'タイトルが修正されているstory' do
      Swing.create({wrong: 'BBB', correct: 'CCC'})
      story = Story.regist_story('【tag1】test「」【BBB】test2「」【CCC】', %w(tag1 tag2))
      expect(story.title).to eq ('test「」test2「」')
    end

    it 'storyが無駄に作られていない' do
      Story.regist_story('aaa', %w(tag1 tag2))
      Story.regist_story('bbb【tag1】', %w(tag1 tag2))
      expect(Story.last.id).to eq(2)
      Story.regist_story('【tag1】aaa', %w(tag1 tag2))
      expect(Story.last.id).to eq(2)
    end
  end

  describe '#regist_tags' do

    it 'タグの登録ができる' do
      story = create(:story)
      story.regist_tags(['tagA'])
      story.regist_tags(['tagB'])
      expect(Story.last.tag_list).to contain_exactly 'tagA', 'tagB'
    end

    it 'タグの複数登録ができる' do
      story = create(:story)
      story.regist_tags(%w(tagA tagB tagC))

      expect(Story.last.tag_list).to contain_exactly *%w(tagA tagB tagC)
    end

    it '重複に対応している' do
      story = create(:story)
      story.regist_tags(%w(tagA tagB tagC))
      story.regist_tags(%w(tagC tagD))

      expect(Story.last.tag_list).to contain_exactly *%w(tagA tagB tagC tagD)
    end

  end

  describe ' first_posted_at' do

    it 'articles が更新されたら first_posted_at が更新される' do
      story = create(:story)

      second = create(:article, :story => story, :posted_at => 1.days.ago.to_s)
      expect(Story.last.first_posted_at.usec).to eq second.posted_at.usec

      last = create(:article, :story => story, :posted_at => Time.now.to_s)
      expect(Story.last.first_posted_at).to eq second.posted_at

      first = create(:article, :story => story, :posted_at => 2.days.ago.to_s)
      expect(Story.last.first_posted_at).to eq first.posted_at
    end
  end

  describe '#rename_title' do
    before do
      @story = create(:story, :title => 'titleA')
      @tags = %w(tagA tagB tagC)
      @story.regist_tags(@tags)
      @a1 = create(:article, :story => @story)
      @a2 = create(:article, :story => @story)
    end

    it '実行後正しいデータが残っている' do
      @story.rename_title 'titleB'

      expect(Story.exists? @story.id).to be_falsey
      expect(Story.last.articles).to contain_exactly @a1, @a2
      expect(Story.last.tag_list).to contain_exactly *@tags
    end

    it 'new_title が被っていた場合' do
      story = create(:story, :title => 'titleB')
      tags = %w(tagC tagD tagE)
      story.regist_tags(tags)
      a1 = create(:article, :story => story, :blog => create(:blog))
      a2 = create(:article, :story => story, :blog => create(:blog))

      @story.rename_title 'titleB'

      expect(Story.exists? @story.id).to be_falsey
      expect(Story.find(story.id).articles).to contain_exactly a1, a2, @a1, @a2
      expect(Story.find(story.id).tag_list).to contain_exactly *((tags + @tags).uniq)
    end
  end

  describe '#bracket_words' do
    it 'works' do
      words = %w(tag1 tag2)
      story = create(:story, :title => "hoge【#{words[0]}】fuga【#{words[1]}】")
      expect(story.bracket_words).to contain_exactly *words
    end
  end

  describe '#remove_bracket_filter' do
    before do
      ActsAsTaggableOn::Tag.create(name: 'AAA')
      Swing.create({wrong: 'BBB', correct: 'CCC'})
    end

    it 'ヒットなし' do
      title = 'hoge【DDD】fuga【EEE】'
      expect(Story.remove_bracket_filter(title, [])).to eq(title)
    end

    it 'Swing にヒット' do
      title = 'hoge【BBB】fuga【EEE】'
      expect(Story.remove_bracket_filter(title, [])).to eq('hogefuga【EEE】')
    end

    it 'Tag にヒット' do
      title = 'hoge【DDD】fuga【AAA】'
      expect(Story.remove_bracket_filter(title, [])).to eq('hoge【DDD】fuga')
    end

    it '複数ヒット' do
      title = 'hoge【BBB】fuga【CCC】piyo【AAA】foo【CCC】'
      expect(Story.remove_bracket_filter(title, [])).to eq('hogefugapiyofoo')
    end

    it '新規 Tag にヒット' do
      title = '【KKK】hoge【BBB】fuga【GGG】'
      expect(Story.remove_bracket_filter(title, ['GGG', 'HHH'])).to eq('【KKK】hogefuga')
    end
  end
end
