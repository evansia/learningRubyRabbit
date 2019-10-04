require 'bunny'

abort "Usage: #{$PROGRAM_NAME} [info] [warning] [error]" if ARGV.empty?

connection = Bunny.new
connection.start

channel = connection.create_channel
exchange = channel.topic('tlogs')
queue = channel.queue('', exclusive: true)

ARGV.each do |severity|
  queue.bind(exchange, routing_key: severity)
end

begin
    puts ' [*] Waiting for messages. To exit press CTRL+C'
    queue.subscribe(block: true) do |_delivery_info, _properties, body|
      puts " [x] Received #{_delivery_info.routing_key}:#{body}"
    end
rescue Interrupt => _
    channel.close
    connection.close
end