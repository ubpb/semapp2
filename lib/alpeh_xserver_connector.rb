require 'net/http'
require 'xml'

class AlpehXserverConnector < AbstractConnector

  def get_books(ils_account)
    url = "http://ubaleph.uni-paderborn.de/X?op=bor-info&bor_id=#{ils_account}&library=pad50"
    xml = Net::HTTP.get_response(URI.parse(url)).body
    doc = XML::Parser.string(xml).parse

    books = {}
    doc.find('//bor-info/item-l').each do |item|
      book = {}
      book[:title]     = content_from_item(item, 'z13/z13-title')
      book[:author]    = content_from_item(item, 'z13/z13-author')
      book[:edition]   = content_from_item(item, 'z13/z13-user-defined-1')
      book[:place]     = content_from_item(item, 'z13/z13-imprint')
      book[:publisher] = nil # TODO: How do we get the publisher out of Alpeh XServer
      book[:year]      = content_from_item(item, 'z13/z13-year')
      book[:isbn]      = content_from_item(item, 'z13/z13-isbn-issn')
      
      signature = content_from_item(item, 'z13/z13-call-no')
      books[signature] = book
    end
    return books
  end

  private

  def content_from_item(item, xpath)
    t = item.find_first(xpath)
    if t and t.content and t.content.length > 0
      return t.content
    else
      return nil
    end
  end

end
