var redis = require('redis');

var handle_subscription = function(err, data) {
}

var handle_subscription_message = function(channel, message) {
  var response = "";

  console.log("nodejs: Received packet => { channel : "+channel+", message : "+message+" }");
  if (channel == "ping") {
    response = message;
  } else if(channel == "vping") {
    response = "nodejs";
  }
  pub.publish("pong", response);
}

var pub = redis.createClient(6379, '127.0.0.1');
var sub = redis.createClient(6379, '127.0.0.1');

pub.on('error', function(err,data) {
  console.error("nodejs: [pub] Error", err);
  process.exit(-1);
});

sub.on('error', function(err,data) {
  console.error("nodejs: [sub] Error", err);
  process.exit(-1);
});

sub.subscribe('ping', handle_subscription);
sub.subscribe('vping', handle_subscription);

sub.on('message', handle_subscription_message);
