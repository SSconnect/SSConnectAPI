# == Schema Information
#
# Table name: blogs
#
#  id         :integer          not null, primary key
#  title      :string
#  url        :string
#  rss        :string
#  selector   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Blog do
  describe '#fetch_rss' do
    describe 'crawl' do
      it 'SSログ' do
        @blog = FactoryGirl.create(:blog_s2_log)
      end

      it '森きのこ' do
        @blog = FactoryGirl.create(:blog_morikinoko)
      end

      it 'あやめ速報' do
        @blog = FactoryGirl.create(:blog_ayamevip)
      end

      it 'エレファント速報' do
        @blog = FactoryGirl.create(:blog_elephant)
      end

      it 'えすえすMode' do
        @blog = FactoryGirl.create(:blog_mode_ss)
      end

      after :each do
        @blog.fetch_rss
        expect(@blog.articles.count).to be > 0
        article = @blog.articles.last
        expect(article.url).not_to be_empty
        expect(article.posted_at).not_to be_nil
        expect(article.story.title).not_to be_empty
        expect(article.story.tag_list.size).to be > 0
      end
    end

    describe ' not crawl' do
      it 'ゆるゆりSS速報' do
        blog = FactoryGirl.create(:blog_yryr)
        blog.fetch_rss
        expect(blog.articles.count).to eq 0
      end
    end

  end
end
