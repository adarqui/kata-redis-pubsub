<?php



function sub_handler($redis, $channel, $message) {
		global $pub;

		$response = "";

		echo "php: [sub] Received packet => { channel : " . $channel . " , message : " . $message . " } \n";
		switch($channel) {
		case "ping": {
				$response = $message;
				break;
		}
		case "vping": {
				$response = "php";
				break;
		}
		default: {
				break;
		}
		}

		try {
				$pub->publish('pong', $response);
		} catch(Exception $e) {
				echo "php: [pub] Error: " . $e->getMessage() . "\n";
		}

}

$pub = new Redis();
$sub = new Redis();

try {
		$pub->connect('127.0.0.1', 6379, 0, NULL, 100);
		$sub->connect('127.0.0.1', 6379, 0, NULL, 100);
} catch(Exception $e) {
		echo "php: Error connecting: " . $e->getMessage() . "\n";
		exit(-1);
}

retrySubscribe:
		try {
				$sub->subscribe(array('ping', 'vping'), 'sub_handler');
				echo "php: [sub] Subscribed!\n";
		} catch(Exception $e) {
				echo "php: [sub] Error: " . $e->getMessage() . "\n";
				goto retrySubscribe;
		}
