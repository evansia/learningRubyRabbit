require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel
exchange = channel.topic('tlogs')

severity = ARGV.shift || 'anon.info'
message = ARGV.empty? ? 'Hello World!' : ARGV.join(' ')

exchange.publish(message, routing_key: severity)
puts " [x] Sent #{severity}:#{message}"

connection.close