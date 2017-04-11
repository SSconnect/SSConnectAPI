require 'rails_helper'

describe Bracket do
  describe 'after create' do
    it 'after create がきちんと行われている' do
      Bracket.create(:title => 'tag1')
      story = Story.regist_story('【tag1】test「」', %w(tag2))
      title = story.title
      tags = story.tag_list
      new_title = Story.space_delete(Story.fix_title(title,tags))
      story.rename_title(new_title)
      expect(story.title).to eq ('test「」')
    end
  end
end