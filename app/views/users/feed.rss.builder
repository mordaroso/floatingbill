xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "the floating bill"
    xml.description meta_description
    xml.link rss_url (@user)

    for news in News.get_all_by_user(@user)
      xml.item do
        xml.title "#{news.user.login} #{news.verb} #{news.object.class.name}"
        xml.description news.text
        xml.link generate_url_by_object(news.object)
        xml.guid generate_url_by_object(news.object)
        xml.pubDate news.time.to_s(:rfc822)
      end
    end

  end
end
