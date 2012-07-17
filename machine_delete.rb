require 'rest_client'

res = RestClient.delete "http://#{ARGV[1]}:3000/machine/#{ARGV[0]}", {:content_type => :json}
#res = RestClient.delete "http://localhost:3000/machine/#{ARGV[0]}", {:content_type => :json}

puts res
