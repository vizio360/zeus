require 'rest_client'
jdata = File.read('instance_put.json')
res = RestClient.put "http://localhost:3000/hermes/#{ARGV[0]}", jdata, {:content_type => :json}

puts res
