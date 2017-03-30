namespace :patch do

  task :change_posted_at => :environment do
    stories = Story.all
    stories.each do |story|
      story.first_posted_at = story.articles.map(&:posted_at).min
      story.save
    end
  end

  task :bracket_to_tag, [:word] => :environment do |_, args|
    word = args.word
    p args, word
    word_bra = "【#{word}】"
    Story.where("title like '%#{word_bra}%'").each do |story|
      title = story.title.gsub word_bra, ''
      story.regist_tag(word)
      story.rename_title(title)
    end
  end

  desc "Patch ミスにより生成された '【' で終わるものを消す"
  task :fix_last_bracket => :environment do
    Story.where("title like '%【'").each do |story|
      # 末尾削除
      story.rename_title story.title[0...-1]
    end
  end

  task :print_brackets => :environment do
    words = []
    Story.where("title like '%【%'").each do |story|
      words += story.title.scan /【.*?】/
    end
    p words.uniq
  end

  task :fix_story_title2 => :environment do
    Story.where("title like '%【%'").each do |story|
      story.bracket_check
    end
  end

  task :fix_last_tag => :environment do
    Story.where("title not like '%」'").each do |story|
      story.tag_list.each do |tag|
        new_title = story.title.gsub /#{tag}$/, ''
        if new_title == story.title
          next
        end
        story = story.rename_title(new_title)
      end
    end
  end

  task :fix_story_title => :environment do
    articles = Article.all

    articles.each do |article|
      story = article.story
      next if story.nil? || story.tag_list.empty?

      tags = story.tag_list
      pattern = /#{tags.first}[^」]*$/
      new_title = story.title.gsub(pattern, '').gsub "【#{tags.first}】", ''
      next if story.title == new_title

      new_story = Story.find_or_create_by(title: new_title)
      story.destroy
      article.update(story: new_story)

      new_story.regist_tag(tags)
      new_story.save
    end
  end

  task :fix_complex_tag => :environment do
    def addTag(wrong, corrects)
      stories = Story.tagged_with(wrong)
      stories.each do |story|
        story.regist_tag(corrects)
        story.tag_list.remove(wrong)
        story.save
      end
      p "#{stories.count} stories #{wrong} => #{corrects.join(',')}"
    end


    addTag('艦隊これくしょん～艦これ～ハイスクール・フリート', %w(艦隊これくしょん～艦これ～ ハイスクール・フリート))
    addTag('ジョジョの奇妙な冒険ドラえもん', %w(ジョジョの奇妙な冒険 ドラえもん))
    addTag('とある魔術の禁書目録DEATH', %w(とある魔術の禁書目録 DEATH))
    addTag('妹姉', %w(妹 姉))
    addTag('ペルソナポケットモンスター', %w(ペルソナ ポケットモンスター))
    addTag('ペルソナけいおん！', %w(ペルソナ けいおん！))
    addTag('ペルソナ二次創作・その他', %w(ペルソナ 二次創作・その他))
    addTag('這いよれ！ニャル子さん二次創作・その他', %w(這いよれ！ニャル子さん 二次創作・その他))
    addTag('とある魔術の禁書目録HUNTER×HUNTER', %w(とある魔術の禁書目録 HUNTER×HUNTER))
    addTag('ペルソナAnother', %w(ペルソナ Another))
    addTag('STEINS;GATEとある魔術の禁書目録', %w(STEINS;GATE とある魔術の禁書目録))
    addTag('氷菓二次創作・その他', %w(氷菓 二次創作・その他))
    addTag('STEINS;GATE中二病でも恋がしたい！', %w(STEINS;GATE 中二病でも恋がしたい！))
    addTag('許嫁幼馴染', %w(許嫁 幼馴染))
    addTag('ドラえもん艦隊これくしょん～艦これ～', %w(ドラえもん 艦隊これくしょん～艦これ～))
    addTag('STEINS;GATE人類は衰退しました', %w(STEINS;GATE 人類は衰退しました))
    addTag('STEINS;GATEDEATH', %w(STEINS;GATE DEATH))
    addTag('ファイナルファンタジーSTEINS;GATE', %w(ファイナルファンタジー STEINS;GATE))
    addTag('とある魔術の禁書目録ドラゴンボール', %w(とある魔術の禁書目録 ドラゴンボール))
    addTag('這いよれ！ニャル子さんとある魔術の禁書目録', %w(這いよれ！ニャル子さん とある魔術の禁書目録))
    addTag('魔導物語二次創作・その他', %w(魔導物語 二次創作・その他))
    addTag('ドラえもんドラゴンボール', %w(ドラえもん ドラゴンボール))
    addTag('幼馴染姉', %w(幼馴染 姉))
    addTag('幼馴染新ジャンル', %w(幼馴染 新ジャンル))
    addTag('魔法少女まどか☆マギカ〈物語〉シリーズ', %w(魔法少女まどか☆マギカ 〈物語〉シリーズ))
    addTag('〈物語〉シリーズとある魔術の禁書目録', %w(〈物語〉シリーズ とある魔術の禁書目録))
    addTag('魔法少女まどか☆マギカDEATH', %w(魔法少女まどか☆マギカ DEATH))
    addTag('〈物語〉シリーズけいおん！', %w(〈物語〉シリーズ けいおん！))
    addTag('やはり俺の青春ラブコメはまちがっている。氷菓', %w(やはり俺の青春ラブコメはまちがっている。 氷菓))
    addTag('男・女艦隊これくしょん～艦これ～', %w(男・女 艦隊これくしょん～艦これ～))
    addTag('ドラゴンボールドラえもん', %w(ドラゴンボール ドラえもん))
    addTag('やはり俺の青春ラブコメはまちがっている。俺の妹がこんなに可愛いわけがない', %w(やはり俺の青春ラブコメはまちがっている。 俺の妹がこんなに可愛いわけがない))
    addTag('女騎士ポケットモンスター', %w(女騎士 ポケットモンスター))
    addTag('新世紀エヴァンゲリオンやはり俺の青春ラブコメはまちがっている。', %w(新世紀エヴァンゲリオンやはり 俺の青春ラブコメはまちがっている。))
    addTag('やはり俺の青春ラブコメはまちがっている。ダンガンロンパ', %w(やはり俺の青春ラブコメはまちがっている。 ダンガンロンパ))
    addTag('ジョジョの奇妙な冒険ドラゴンボール', %w(ジョジョの奇妙な冒険 ドラゴンボール))
    addTag('ファンタジー二次創作・その他', %w(ファンタジー 二次創作・その他))
    addTag('二次創作・その他女騎士', %w(二次創作・その他 女騎士))
    addTag('やはり俺の青春ラブコメはまちがっている。ドラゴンボール', %w(やはり俺の青春ラブコメはまちがっている。 ドラゴンボール))
    addTag('やはり俺の青春ラブコメはまちがっている。とある魔術の禁書目録', %w(やはり俺の青春ラブコメはまちがっている。 とある魔術の禁書目録))
    addTag('這いよれ！ニャル子さん魔法少女まどか☆マギカ', %w(這いよれ！ニャル子さん 魔法少女まどか☆マギカ))
    addTag('艦隊これくしょん～艦これ～PSYCHO-PASS', %w(艦隊これくしょん～艦これ～ PSYCHO-PASS))
    addTag('艦隊これくしょん～艦これ～東方Project', %w(艦隊これくしょん～艦これ～ 東方Project))
    addTag('ポケットモンスターSTEINS;GATE', %w(ポケットモンスター STEINS;GATE))
    addTag('こちら葛飾区亀有公園前派出所とある魔術の禁書目録', %w(こちら葛飾区亀有公園前派出所 とある魔術の禁書目録))
    addTag('ダンガンロンパDEATH', %w(ダンガンロンパ DEATH))
    addTag('ドラえもんPSYCHO-PASS', %w(ドラえもん PSYCHO-PASS))
    addTag('ドラゴンボールめだかボックス', %w(ドラゴンボール めだかボックス))
    addTag('PSYCHO-PASS二次創作・その他', %w(PSYCHO-PASS 二次創作・その他))
    addTag('ダンガンロンパジブリ', %w(ダンガンロンパ ジブリ))
    addTag('涼宮ハルヒの憂鬱魔法少女まどか☆マギカ', %w(涼宮ハルヒの憂鬱 魔法少女まどか☆マギカ))
    addTag('涼宮ハルヒの憂鬱けいおん！', %w(涼宮ハルヒの憂鬱 けいおん！))
    addTag('ポケットモンスター魔法少女まどか☆マギカ', %w(ポケットモンスター 魔法少女まどか☆マギカ))
    addTag('魔法少女まどか☆マギカガンダム', %w(魔法少女まどか☆マギカ ガンダム))
    addTag('けいおん！とある魔術の禁書目録', %w(けいおん！ とある魔術の禁書目録))
    addTag('けいおん！ジャンプ', %w(けいおん！ ジャンプ))
    addTag('俺の妹がこんなに可愛いわけがないとある魔術の禁書目録', %w(俺の妹がこんなに可愛いわけがない とある魔術の禁書目録))
    addTag('涼宮ハルヒの憂鬱ジャンプ', %w(涼宮ハルヒの憂鬱 ジャンプ))
    addTag('幼女姉妹・百合', %w(幼女 姉妹・百合))
    addTag('けいおん！魔法少女まどか☆マギカ', %w(けいおん！魔法少女 まどか☆マギカ))
    addTag('涼宮ハルヒの憂鬱ローゼンメイデン', %w(涼宮ハルヒの憂鬱 ローゼンメイデン))
    addTag('涼宮ハルヒの憂鬱新世紀エヴァンゲリオン', %w(涼宮ハルヒの憂鬱 新世紀エヴァンゲリオン))
    addTag('男・女新ジャンル', %w(男・女 新ジャンル))
    addTag('涼宮ハルヒの憂鬱ポケットモンスター', %w(涼宮ハルヒの憂鬱 ポケットモンスター))
    addTag('新世紀エヴァンゲリオン涼宮ハルヒの憂鬱', %w(新世紀エヴァンゲリオン 涼宮ハルヒの憂鬱))
    addTag('とある魔術の禁書目録涼宮ハルヒの憂鬱', %w(とある魔術の禁書目録 涼宮ハルヒの憂鬱))
    addTag('とある魔術の禁書目録東方Project', %w(とある魔術の禁書目録 東方Project))
    addTag('魔法少女まどか☆マギカその他オリジナル', %w(魔法少女まどか☆マギカ その他オリジナル))
    addTag('とある魔術の禁書目録ゆるゆり', %w(とある魔術の禁書目録 ゆるゆり))
    addTag('魔法少女まどか☆マギカHUNTER×HUNTER', %w(魔法少女まどか☆マギカ HUNTER×HUNTER))
    addTag('HUNTER×HUNTERドラゴンボール', %w(HUNTER×HUNTER ドラゴンボール))
    addTag('二次創作・その他とある魔術の禁書目録', %w(二次創作・その他 とある魔術の禁書目録))
    addTag('魔法少女まどか☆マギカやはり俺の青春ラブコメはまちがっている。', %w(魔法少女まどか☆マギカやはり 俺の青春ラブコメはまちがっている。))
    addTag('東方Projectジョジョの奇妙な冒険', %w(東方Project ジョジョの奇妙な冒険))
    addTag('新世紀エヴァンゲリオンめだかボックス', %w(新世紀エヴァンゲリオン めだかボックス))
    addTag('ポケットモンスター二次創作・その他', %w(ポケットモンスター 二次創作・その他))
    addTag('ドラゴンボールHUNTER×HUNTER', %w(ドラゴンボール HUNTER×HUNTER))
    addTag('ローゼンメイデンとある魔術の禁書目録', %w(ローゼンメイデン とある魔術の禁書目録))
    addTag('東方Project這いよれ！ニャル子さん', %w(東方Project 這いよれ！ニャル子さん))
    addTag('俺の妹がこんなに可愛いわけがない二次創作・その他', %w(俺の妹がこんなに可愛いわけがない 二次創作・その他))
    addTag('魔王・勇者ドラゴンボール', %w(魔王・勇者 ドラゴンボール))
    addTag('ゆるゆりソードアート・オンライン', %w(ゆるゆり ソードアート・オンライン))
    addTag('カイジ・アカギ・福本伸行ポケットモンスター', %w(カイジ・アカギ・福本伸行 ポケットモンスター))
    addTag('二次創作・その他ポケットモンスター', %w(二次創作・その他 ポケットモンスター))
    addTag('東方Project魔法少女まどか☆マギカ', %w(東方Project 魔法少女まどか☆マギカ))
    addTag('魔法少女まどか☆マギカPSYCHO-PASS', %w(魔法少女まどか☆マギカ PSYCHO-PASS))
    addTag('Anotherジョジョの奇妙な冒険', %w(Another ジョジョの奇妙な冒険))
    addTag('けいおん！銀河英雄伝説', %w(けいおん！ 銀河英雄伝説))
    addTag('二次創作・その他ドラえもん', %w(二次創作・その他 ドラえもん))
    addTag('魔法少女まどか☆マギカ魔王・勇者', %w(魔法少女まどか☆マギカ 魔王・勇者))
    addTag('ゆるゆりポケットモンスター', %w(ゆるゆり ポケットモンスター))
    addTag('けいおん！ドラえもん', %w(けいおん！ ドラえもん))
    addTag('魔法少女まどか☆マギカドラえもん', %w(魔法少女まどか☆マギカ ドラえもん))
    addTag('魔法少女まどか☆マギカ銀河英雄伝説', %w(魔法少女まどか☆マギカ 銀河英雄伝説))
    addTag('Anotherポケットモンスター', %w(Another ポケットモンスター))
    addTag('魔法少女まどか☆マギカめだかボックス', %w(魔法少女まどか☆マギカ めだかボックス))
    addTag('けいおん！ドラゴンボール', %w(けいおん！ ドラゴンボール))
    addTag('邪気眼幼女', %w(邪気眼 幼女))
    addTag('邪気眼けいおん！', %w(邪気眼 けいおん！))

    addTag('魔法少女まどか☆マギカ二次創作・その他', %w(魔法少女まどか☆マギカ 二次創作・その他))
    addTag('とある魔術の禁書目録二次創作・その他', %w(とある魔術の禁書目録 二次創作・その他))
    addTag('艦隊これくしょん～艦これ～二次創作・その他', %w(艦隊これくしょん～艦これ～ 二次創作・その他))
    addTag('やはり俺の青春ラブコメはまちがっている。〈物語〉シリーズ', %w(やはり俺の青春ラブコメはまちがっている。 〈物語〉シリーズ))
    addTag('ガールズ&パンツァー二次創作・その他', %w(ガールズ&パンツァー 二次創作・その他))
    addTag('〈物語〉シリーズ二次創作・その他', %w(〈物語〉シリーズ 二次創作・その他))
    addTag('涼宮ハルヒの憂鬱STEINS;GATE', %w(涼宮ハルヒの憂鬱 STEINS;GATE))
    addTag('魔法少女まどか☆マギカ人類は衰退しました', %w(魔法少女まどか☆マギカ 人類は衰退しました))
    addTag('ダンガンロンパ二次創作・その他', %w(ダンガンロンパ 二次創作・その他))
    addTag('ゆるゆり魔法少女まどか☆マギカ', %w(ゆるゆり 魔法少女まどか☆マギカ'))
    addTag('STEINS;GATE二次創作・その他', %w(STEINS;GATE 二次創作・その他))
    addTag('魔法少女まどか☆マギカ東方Project', %w(魔法少女まどか☆マギカ 東方Project))
    addTag('新世紀エヴァンゲリオン二次創作・その他', %w(新世紀エヴァンゲリオン 二次創作・その他))
    addTag('僕のヒーローアカデミアドラゴンボール', %w(僕のヒーローアカデミア ドラゴンボール))
    addTag('やはり俺の青春ラブコメはまちがっている。二次創作・その他', %w(やはり俺の青春ラブコメはまちがっている。 二次創作・その他))
    addTag('魔法少女まどか☆マギカポケットモンスター', %w(魔法少女まどか☆マギカ ポケットモンスター))
    addTag('ドラゴンボール二次創作・その他', %w(ドラゴンボール 二次創作・その他))
    addTag('魔法少女まどか☆マギカとある魔術の禁書目録', %w(魔法少女まどか☆マギカ とある魔術の禁書目録))
    addTag('ドラゴンボール魔法少女まどか☆マギカ', %w(ドラゴンボール 魔法少女まどか☆マギカ))
    addTag('まとめリンク艦隊これくしょん～艦これ～', %w(まとめリンク 艦隊これくしょん～艦これ～))
    addTag('とある魔術の禁書目録めだかボックス', %w(とある魔術の禁書目録 めだかボックス))
    addTag('魔法少女まどか☆マギカドラゴンボール', %w(魔法少女まどか☆マギカ ドラゴンボール))
    addTag('魔法少女まどか☆マギカジョジョの奇妙な冒険', %w(魔法少女まどか☆マギカ ジョジョの奇妙な冒険))
    addTag('ジョジョの奇妙な冒険魔法少女まどか☆マギカ', %w(ジョジョの奇妙な冒険 魔法少女まどか☆マギカ))
    addTag('ガールズ&パンツァーこちら葛飾区亀有公園前派出所', %w(ガールズ&パンツァー こちら葛飾区亀有公園前派出所))
    addTag('幼馴染妹', %w(幼 馴染妹))
    addTag('魔法少女まどか☆マギカSTEINS;GATE', %w(魔法少女まどか☆マギカ STEINS;GATE))
    addTag('ジョジョの奇妙な冒険二次創作・その他', %w(ジョジョの奇妙な冒険 二次創作・その他))
    addTag('魔法少女まどか☆マギカ涼宮ハルヒの憂鬱', %w(魔法少女まどか☆マギカ 涼宮ハルヒの憂鬱))
    addTag('けいおん！ポケットモンスター', %w(けいおん！ ポケットモンスター))
    addTag('涼宮ハルヒの憂鬱とある魔術の禁書目録', %w(涼宮ハルヒの憂鬱 とある魔術の禁書目録))
    addTag('氷菓けいおん！', %w(氷菓 けいおん！))
    addTag('☆糞SS', %w(☆糞 SS))
    addTag('とある魔術の禁書目録やはり俺の青春ラブコメはまちがっている。', %w(とある魔術の禁書目録 やはり俺の青春ラブコメはまちがっている。))
    addTag('涼宮ハルヒの憂鬱ドラゴンボール', %w(涼宮ハルヒの憂鬱 ドラゴンボール))
    addTag('こちら葛飾区亀有公園前派出所二次創作・その他', %w(こちら葛飾区亀有公園前派出所 二次創作・その他))
    addTag('とある魔術の禁書目録ダンガンロンパ', %w(とある魔術の禁書目録 ダンガンロンパ))
    addTag('やはり俺の青春ラブコメはまちがっている。ポケットモンスター', %w(やはり俺の青春ラブコメはまちがっている。 ポケットモンスター))
    addTag('けいおん！ペルソナ', %w(けいおん！ ペルソナ))
    addTag('ドラえもん二次創作・その他', %w(ドラえもん 二次創作・その他))
    addTag('魔法少女まどか☆マギカジャンプ', %w(魔法少女まどか☆マギカ ジャンプ))
    addTag('やはり俺の青春ラブコメはまちがっている。ジャンプ', %w(やはり俺の青春ラブコメはまちがっている。 ジャンプ))
    addTag('STEINS;GATEジャンプ', %w(STEINS;GATE ジャンプ))
    addTag('GS美神極楽大作戦!!二次創作・その他', %w(GS美神極楽大作戦!! 二次創作・その他))
    addTag('STEINS;GATE魔法少女まどか☆マギカ', %w(STEINS;GATE 魔法少女まどか☆マギカ))
    addTag('やはり俺の青春ラブコメはまちがっている。がっこうぐらし！', %w(やはり俺の青春ラブコメはまちがっている。 がっこうぐらし！))
    addTag('まとめリンクやはり俺の青春ラブコメはまちがっている。', %w(まとめリンク やはり俺の青春ラブコメはまちがっている。))
    addTag('〈物語〉シリーズやはり俺の青春ラブコメはまちがっている。', %w(〈物語〉シリーズ やはり俺の青春ラブコメはまちがっている。))
    addTag('ニセコイ二次創作・その他', %w(ニセコイ 二次創作・その他))
    addTag('俺の妹がこんなに可愛いわけがないやはり俺の青春ラブコメはまちがっている。', %w(俺の妹がこんなに可愛いわけがない やはり俺の青春ラブコメはまちがっている。))
    addTag('とある魔術の禁書目録ソードアート・オンライン', %w(とある魔術の禁書目録 ソードアート・オンライン))
    addTag('けいおん！二次創作・その他', %w(けいおん！ 二次創作・その他))
    addTag('ダンガンロンパとある魔術の禁書目録', %w(ダンガンロンパ とある魔術の禁書目録))
    addTag('涼宮ハルヒの憂鬱二次創作・その他', %w(涼宮ハルヒの憂鬱 二次創作・その他))
    addTag('Another二次創作・その他', %w(Another 二次創作・その他))
    addTag('ローゼンメイデン二次創作・その他', %w(ローゼンメイデン 二次創作・その他))
    addTag('とある魔術の禁書目録魔法少女まどか☆マギカ', %w(とある魔術の禁書目録 魔法少女まどか☆マギカ))
    addTag('とある魔術の禁書目録けいおん！', %w(とある魔術の禁書目録 けいおん！))
    addTag('魔法少女まどか☆マギカ這いよれ！ニャル子さん', %w(魔法少女まどか☆マギカ 這いよれ！ニャル子さん))
    addTag('魔法少女まどか☆マギカローゼンメイデン', %w(魔法少女まどか☆マギカ ローゼンメイデン))
    addTag('ソードアート・オンライン二次創作・その他', %w(ソードアート・オンライン 二次創作・その他))
    addTag('魔法少女まどか☆マギカカイジ・アカギ・福本伸行', %w(魔法少女まどか☆マギカ カイジ・アカギ・福本伸行))
    addTag('ゆるゆりドラえもん', %w(ゆるゆり ドラえもん))
    addTag('Another魔法少女まどか☆マギカ', %w(Another 魔法少女まどか☆マギカ))
    addTag('魔法少女まどか☆マギカ新世紀エヴァンゲリオン', %w(魔法少女まどか☆マギカ 新世紀エヴァンゲリオン))
    addTag('幼馴染姉妹・百合', %w(幼馴染 姉妹・百合))
    addTag('ポケットモンスターカイジ・アカギ・福本伸行', %w(ポケットモンスター カイジ・アカギ・福本伸行))
    addTag('ドラゴンボール涼宮ハルヒの憂鬱', %w(ドラゴンボール 涼宮ハルヒの憂鬱))
    addTag('艦隊これくしょん～艦これ～ガールズ&パンツァー', %w(艦隊これくしょん～艦これ～ ガールズ&パンツァー))
    addTag('こちら葛飾区亀有公園前派出所ハリー・ポッター', %w(こちら葛飾区亀有公園前派出所 ハリー・ポッター))
    addTag('がっこうぐらし！こちら葛飾区亀有公園前派出所', %w(がっこうぐらし！ こちら葛飾区亀有公園前派出所))
    addTag('とある魔術の禁書目録〈物語〉シリーズ', %w(とある魔術の禁書目録 〈物語〉シリーズ))
    addTag('HUNTER×HUNTERジョジョの奇妙な冒険', %w(HUNTER×HUNTER ジョジョの奇妙な冒険))
    addTag('妹幼馴染', %w(妹 幼馴染))
    addTag('こちら葛飾区亀有公園前派出所ドラえもん', %w(こちら葛飾区亀有公園前派出所 ドラえもん))
    addTag('魔王・勇者幼馴染', %w(魔王・勇者 幼馴染))
    addTag('僕は友達が少ない俺の妹がこんなに可愛いわけがない', %w(僕は友達が少ない 俺の妹がこんなに可愛いわけがない))
    addTag('男・女天使・悪魔', %w(男・女 天使・悪魔))
    addTag('ガールズ&パンツァー東方Project', %w(ガールズ&パンツァー 東方Project))
  end
end