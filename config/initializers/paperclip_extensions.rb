require 'digest'

# Paperclips defaults
Paperclip::Attachment.default_options[:path] = ':rails_root/data/attachments/:hashed_path/:id_:basename_:style.:extension'
Paperclip::Attachment.default_options[:url]  = '/download/:id/:style'

# Make use of a hashed path for paperclip
Paperclip.interpolates(:hashed_path) do |attachment, style|
  hash = Digest::MD5.hexdigest(attachment.instance.id.to_s << 'df8jsafg23756fg9g734jk5heg7843oisfdofg907834u')
  
  hash_path = hash.slice!(0..1)
  2.times do
    hash_path += '/' + hash.slice!(0..1)
  end

  return hash_path
end
