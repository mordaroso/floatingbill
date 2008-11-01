xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "the floating bill"
    xml.description meta_description
    xml.link rss_url (@user)

    for activity in @activities
      xml.item do
        xml.title "#{activity.user.login} #{activity.verb} #{activity.object.class.name}"
        xml.description activity.text
        xml.link generate_url_by_object(activity.object)
        xml.guid "#{generate_url_by_object(activity.object)}##{activity.verb}_#{activity.time.to_i}"
        xml.pubDate activity.time.to_s(:rfc822)
      end
    end

  end
end
