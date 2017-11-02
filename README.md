# SSConnectAPI
[![All Contributors](https://img.shields.io/badge/all_contributors-2-orange.svg?style=flat-square)](#contributors)

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

## Contributors

Thanks goes to these wonderful people ([emoji key](https://github.com/kentcdodds/all-contributors#emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
| [<img src="https://avatars3.githubusercontent.com/u/2284908?v=4" width="100px;"/><br /><sub>elzup</sub>](https://elzup.com)<br />[💻](https://github.com/SSconnect/SSConnectAPI/commits?author=elzup "Code") [🤔](#ideas-elzup "Ideas, Planning, & Feedback") [⚠️](https://github.com/SSconnect/SSConnectAPI/commits?author=elzup "Tests") | [<img src="https://avatars0.githubusercontent.com/u/22675420?v=4" width="100px;"/><br /><sub>atsuo</sub>](https://github.com/atsuo1203)<br />[💻](https://github.com/SSconnect/SSConnectAPI/commits?author=atsuo1203 "Code") [🤔](#ideas-atsuo1203 "Ideas, Planning, & Feedback") |
| :---: | :---: |
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/kentcdodds/all-contributors) specification. Contributions of any kind welcome!