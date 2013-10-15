use Redis;
use Data::Dumper;
use Try::Tiny;

my $sub, $pub;

$sub = Redis->new(server => '127.0.0.1:6379', reconnect => 60);
$pub = Redis->new(server => '127.0.0.1:6379', reconnect => 60);

$sub->subscribe(
		'ping',
		'vping',
		sub {
				my ($message, $channel, $subscribed_channel) = @_;
				print "perl: Received packet: { channel : $channel, message : $message }\n";

				if($channel eq "ping") {
						$pub->publish("pong", $message);
				}
				elsif ($channel eq "vping") {
						$pub->publish("pong", "perl");
				}
		}
);

$sub->wait_for_messages(0) while 1;
