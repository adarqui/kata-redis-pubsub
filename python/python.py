import redis
import sys
import signal

def signal_handler(signal, frame):
	print "python: Goodbye."
	sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

pub = redis.StrictRedis(host='127.0.0.1',port=6379,db=0)

r = redis.Redis(host='127.0.0.1',port=6379,db=0)

try:
	sub = r.pubsub()
	sub.subscribe(['ping','vping'])
except:
	print "python: [sub] Unable to subscribe."
	sys.exit(-1)


while True:
		packet = next(sub.listen())
		print "python: Received packet =>", packet
		channel = packet['channel']
		if channel == "ping":
				pub.publish('pong', packet['data'])
		elif channel == "vping":
				pub.publish('pong', 'python')
