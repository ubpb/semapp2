require 'aleph_connector'

Aleph::Connector.base_url           = 'https://ubex/X'
Aleph::Connector.library            = 'pad50'
Aleph::Connector.search_base        = 'pbaus'
Aleph::Connector.allowed_user_types = [/^PA.+/, /\APS.+\Z/]
Aleph::Connector.allowed_ban_codes  = [/^00$/]
