require 'rest_client'
jdata = { :instanceId => "#{ARGV[0]}" }
res = RestClient.post "http://localhost:3000/machine/delete/", jdata, {:content_type => :json}

puts res
