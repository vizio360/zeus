require 'rest_client'
jdata = File.read('machine_post.json')
res = RestClient.post "http://localhost:3000/machine/create/", jdata, {:content_type => :json}

puts res
