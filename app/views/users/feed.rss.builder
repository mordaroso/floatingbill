xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "the floating bill"
    xml.description meta_description
    xml.link rss_url (@user)

    for news in News.get_all_by_user(@user)
      xml.item do
        xml.title "#{news.user.login} #{news.verb} #{news.type}"
        case news.type
          when 'bill'
            xml.description news.object.description
            xml.link bill_url(news.object)
            xml.guid bill_url(news.object)
          when 'transfer'
            xml.description 'Transfer'
            xml.link transfer_url(news.object)
            xml.guid transfer_url(news.object)
          end
        xml.pubDate news.time.to_s(:rfc822)
      end
    end

  end
end
