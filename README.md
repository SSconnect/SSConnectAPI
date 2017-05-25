# SSConnectAPI

## 概要
SSをまとめるAPI

## バージョン
* ruby  2.4.0
* rails 5.0.1

## setup
1. bundle install
2. bin/rails db:migrate RAILS_ENV=development
3. bin/rails db:seed
4. bin/rails sample:blog_insert
5. bin/rails crawl:rss
6. bin/rails s


## test

```
# main
rspec

# scraping test
rspec spec_crawl/models/blog_spec.rb
```
