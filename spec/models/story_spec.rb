require 'rails_helper'

describe Story do
  it 'regist_tag タグの登録ができる' do
    story = create(:story)
    story.regist_tag('tagA')
    story.regist_tag('tagB')

    expect(Story.last.tag_list).to contain_exactly 'tagA', 'tagB'
  end

  it 'regist_tag タグの複数登録ができる' do
    story = create(:story)
    story.regist_tag(%w(tagA tagB tagC))

    expect(Story.last.tag_list).to contain_exactly *%w(tagA tagB tagC)
  end

  it 'regist_tag 重複に対応している' do
    story = create(:story)
    story.regist_tag(%w(tagA tagB tagC))
    story.regist_tag(%w(tagC tagD))

    expect(Story.last.tag_list).to contain_exactly *%w(tagA tagB tagC tagD)
  end

  it 'articles が更新されたら first_posted_at が更新される' do
    story = create(:story)

    second = create(:article, :story => story, :posted_at => 1.days.ago.to_s)
    expect(Story.last.first_posted_at.usec).to eq second.posted_at.usec

    last = create(:article, :story => story, :posted_at => Time.now.to_s)
    expect(Story.last.first_posted_at).to eq second.posted_at

    first = create(:article, :story => story, :posted_at => 2.days.ago.to_s)
    expect(Story.last.first_posted_at).to eq first.posted_at
  end

  it 'rename_title rename 後正しいデータが残っている' do
    story = create(:story, :title => 'titleA')
    tags = %w(tagA tagB tagC)
    story.regist_tag(tags)
    a1 = create(:article, :story => story, :blog => create(:blog))
    a2 = create(:article, :story => story, :blog => create(:blog))

    story.rename_title 'titleB'

    expect(Story.exists? story).to be_falsey
    expect(Story.last.articles).to contain_exactly a1, a2
    expect(Story.last.tag_list).to contain_exactly *tags
  end

  it 'rename_title new_title が被っていた場合のチェック' do

  end

end
