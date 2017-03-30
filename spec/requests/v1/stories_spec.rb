require 'rails_helper'

describe 'GET /v1/stories' do
  describe ' basic' do
    before do
      30.times do |i|
        story = create(:story)
        story.regist_tag(%w(tagA tagB))
        create(:article, :story => story)
        create(:article, :story => story)
      end
      get '/v1/stories'
    end

    it '200 OK' do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it '一覧が取得出来る' do
      json = JSON.parse(response.body)
      expect(json.size).to eq(25)
    end
  end

  describe ' search' do
    before do
      # id: 1
      story1 = create(:story, :title => 'AAA「hoge」BBB「fuga」')
      story1.regist_tag(%w(tagA tagB))
      create(:article, :story => story1, :posted_at => 3.days.ago.to_s)

      # id: 2
      story2 = create(:story, :title => 'AAA「hoge」CCC「fuga」')
      story2.regist_tag(%w(tagA tagC))
      create(:article, :story => story2, :posted_at => 1.days.ago.to_s)

      # id: 3
      story3 = create(:story, :title => 'CCC「hoge」DDD「fuga」')
      story3.regist_tag(%w(tagC tagD))
      create(:article, :story => story3, :posted_at => 5.days.ago.to_s)
    end

    it '結果が first_posted_at で sort されている' do
      get '/v1/stories'
      json = JSON.parse(response.body)
      ids = json.map { |story| story['id'] }
      expect(ids).to eq([2, 1, 3])
    end

    it '検索できる' do
      get '/v1/stories', params: {q: 'CCC'}
      json = JSON.parse(response.body)
      ids = json.map { |story| story['id'] }
      expect(ids).to contain_exactly 2, 3
    end

    it 'タグ絞込できる' do
      get '/v1/stories', params: {tag: 'tagA'}
      json = JSON.parse(response.body)
      ids = json.map { |story| story['id'] }
      expect(ids).to contain_exactly 1, 2
    end

    it '空の param を無視する' do
      get '/v1/stories', params: {tag: '', q: ''}
      json = JSON.parse(response.body)
      ids = json.map { |story| story['id'] }
      expect(ids).to contain_exactly 1, 2, 3
    end
  end
end
