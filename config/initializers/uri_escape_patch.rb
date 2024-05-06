# URI#escape was deprecated and later removed
# This is a monkey patch to bring it back unsing CGI.escape

require "uri"

module URI
  class << self
    def escape(str)
      CGI.escape(str)
    end
  end
end
