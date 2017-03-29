require 'rails_helper'

describe 'GET /v1/stories' do
  before do
    @story = create(:story)
    tags = %w(tagA tagB tagC)
    @story.regist_tag(tags)
    create(:article, :story => @story)
    create(:article, :story => @story)

    @story2 = create(:story)
    tags = %w(tagA tagB tagC)
    @story2.regist_tag(tags)
    create(:article, :story => @story2)
    create(:article, :story => @story2)
    get '/v1/stories'
  end

  it '200 OK' do
    expect(response).to be_success
    expect(response.status).to eq(200)
  end

end
