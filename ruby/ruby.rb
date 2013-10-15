require "redis"

trap("INT") do
  print "ruby: Goodbye.\n"
  exit(0)
end


begin
  pub = Redis.new(:host => "127.0.0.1", :port => 6379)
  sub = Redis.new(:host => "127.0.0.1", :port => 6379)
rescue
  print "ruby: Unable to create pubsub channels"
  exit(-1)
end

begin
  sub.subscribe(["ping","vping"]) do |on|

    on.message do |channel,message|

      print "ruby: Received packet => #{channel} #{message}\n"

      if channel.eql? "ping"
        pub.publish("pong", message)
      elsif channel.eql? "vping"
        pub.publish("pong", "ruby")
      end
    end

  end
rescue
  print "Unable to subscribe\n"
  exit(-1)
end
