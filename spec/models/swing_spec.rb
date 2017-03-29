# == Schema Information
#
# Table name: swings
#
#  id         :integer          not null, primary key
#  wrong      :string
#  correct    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Swing do
  it 'trans で辞書が使える' do
    Swing.create({wrong: 'AAA', correct: 'BBB'})
    expect(Swing.trans('AAA')).to eq 'BBB'
    Swing.lib_drop
  end

  it 'after_create により既存の Story タグも修正される' do
    story = create(:story)
    story.regist_tag(%w(AAA BBB))
    Swing.create(wrong: 'AAA', correct: 'CCC')
    expect(Story.last.tag_list).to contain_exactly 'BBB', 'CCC'
    Swing.lib_drop
  end
end
