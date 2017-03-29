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
  describe '#regist_tag' do

    it 'タグの登録ができる' do
      story = create(:story)
      story.regist_tag('tagA')
      story.regist_tag('tagB')

      expect(Story.last.tag_list).to contain_exactly 'tagA', 'tagB'
    end

    it 'タグの複数登録ができる' do
      story = create(:story)
      story.regist_tag(%w(tagA tagB tagC))

      expect(Story.last.tag_list).to contain_exactly *%w(tagA tagB tagC)
    end

    it '重複に対応している' do
      story = create(:story)
      story.regist_tag(%w(tagA tagB tagC))
      story.regist_tag(%w(tagC tagD))

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
      @story.regist_tag(@tags)
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
      story.regist_tag(tags)
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

  describe '#bracket_check' do
    before do
      @words = %w(word1 word2)
      @title = "hoge【#{@words[0]}】fuga【#{@words[1]}】"
      @story = create(:story, :title => @title)
    end

    it 'ヒットなし' do
      @story.bracket_check
      expect(Story.last.title).to eq(@title)
      expect(Story.last).to @story
    end

    it 'Swing にヒット' do
      swing = Swing.regist(@words[0], 'tag')
      @story.bracket_check
      expect(Story.last.title).to eq("hogefuga【#{@words[1]}】")
      expect(Story.last.tag_list).to eq([swing.correct])
    end

    it 'Tag にヒット' do
      create(:story).regist_tag(@words[1])
      expect(Story.find(@story.id).title).to eq("hoge【#{@words[0]}】fuga")
      expect(Story.find(@story.id).tag_list).to eq([@words[1]])
    end

    it '複数ヒット' do
      swing = Swing.regist(@words[1], 'tag')
      create(:story).regist_tag(@words[0])
      expect(Story.find(@story.id).title).to eq("hogefuga")
      expect(Story.find(@story.id).tag_list).to eq([@words[0], swing.correct])
    end
  end
end
