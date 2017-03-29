require 'rails_helper'

describe Swing do
  it 'trans で辞書が使える' do
    Swing.create({wrong: 'AAA', correct: 'BBB'})
    expect(Swing.trans('AAA')).to eq 'BBB'
  end

  it 'after_create により既存の Story タグも修正される' do
    story = create(:story)
    story.regist_tag(%w(AAA BBB))
    Swing.create(wrong: 'AAA', correct: 'CCC')
  end
end
