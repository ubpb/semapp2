class Rack::Attack

  # Block requests for bots and crawlers
  Rack::Attack.blocklist('block bots and crawlers') do |req|
    req.user_agent =~ /bot|crawler|spider/i
  end

end
