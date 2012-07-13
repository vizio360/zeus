require 'rest_client'
jdata = File.read('machine_create_post.json')
#res = RestClient.post "http://ec2-184-73-2-108.compute-1.amazonaws.com:3000/machine/create/", jdata, {:content_type => :json}
res = RestClient.post "http://localhost:3000/machine/create/", jdata, {:content_type => :json}

puts res
