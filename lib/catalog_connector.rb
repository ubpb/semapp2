class CatalogConnector

  def self.search_print_title(search_string)
    search_string = Addressable::URI.encode_component(search_string, Addressable::URI::CharacterClasses::UNRESERVED)
    url = "#{SemApp2.catalog_base_url}/local/s.json?sr[q,any]=#{search_string}&sr[a,-material_type]=online_resource&sr[a,resource_type]=monograph"

    response = RestClient.get(url)
    return nil unless response.code == 200

    JSON.parse(response.body)
  end

end
