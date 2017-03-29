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
end
