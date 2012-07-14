require 'rest_client'
jdata = { :instanceId => "#{ARGV[0]}" }
res = RestClient.post "http://ec2-23-20-211-210.compute-1.amazonaws.com:3000/machine/delete/", jdata, {:content_type => :json}
#res = RestClient.post "http://localhost:3000/machine/delete/", jdata, {:content_type => :json}

puts res
