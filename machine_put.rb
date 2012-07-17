require 'rest_client'
jdata = File.read('machine_put.json')
res = RestClient.put "http://#{ARGV[0]}:3000/machine/#{ARGV[1]}", jdata, {:content_type => :json}
#res = RestClient.post "http://localhost:3000/machine/create/", jdata, {:content_type => :json}

puts res
