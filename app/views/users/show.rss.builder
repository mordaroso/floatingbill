xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "the floating bill"
    xml.description meta_description
    xml.link rss_url (@user)

    for payment in @user.payments
      xml.item do
        xml.title payment.bill.name
        xml.description payment.bill.description
        xml.pubDate payment.bill.created_at.to_s(:rfc822)
        xml.link bill_url(payment.bill)
        xml.guid bill_url(payment.bill)
      end
    end

  end
end
