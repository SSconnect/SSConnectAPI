describe 'GET /v1/tags' do
  describe ' basic' do
    before do
      create(:story).regist_tags(%w(tagA tagB tagC))
      create(:story).regist_tags(%w(tagD tagE tagF))
      get '/v1/tags'
    end

    it '200 OK' do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it '一覧が取得出来る' do
      json = JSON.parse(response.body)
      expect(json.size).to eq(6)
    end

    it '正しい構造である' do
      json = JSON.parse(response.body)
      tag = json.first
      expect(tag['name']).not_to be_nil
      expect(tag['taggings_count']).not_to be_nil
    end
  end
end
