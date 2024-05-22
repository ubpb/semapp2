# URI#escape was deprecated and later removed.
# This is a monkey patch to bring it back as some gems (Paperclip) still use it.
# Taken from https://gist.github.com/corytheboyd-smartsheet/6d39344a8d03713d8a345d80d97ec076

URI.class_eval do
  class << self
    def escape(*arg)
      URI::DEFAULT_PARSER.escape(*arg)
    end
    alias encode escape

    def unescape(*arg)
      URI::DEFAULT_PARSER.unescape(*arg)
    end
    alias decode unescape
  end
end
