require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel
exchange = channel.fanout('logs')
queue = channel.queue('', exclusive: true)
queue.bind(exchange)

begin
    puts ' [*] Waiting for messages. To exit press CTRL+C'
    queue.subscribe(block: true) do |_delivery_info, _properties, body|
      puts " [x] Received #{body}"
    end
rescue Interrupt => _
    channel.close
    connection.close
end