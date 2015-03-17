require 'fog'

connection = Fog::Storage.new({
  :provider                 => 'AWS',
  :aws_access_key_id        => ENV[AWS_ACCESS_KEY_ID],
  :aws_secret_access_key    => ENV[AWS_`SECRET_ACCESS_KEY]
})