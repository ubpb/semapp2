class User < ActiveRecord::Base

  acts_as_authentic do |c|
    # for available options see documentation in: Authlogic::ActsAsAuthentic
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end

end
