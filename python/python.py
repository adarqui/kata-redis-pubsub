import redis
import string
from types import *

pub = redis.StrictRedis(host='127.0.0.1',port=6379,db=0)

r = redis.Redis(host='127.0.0.1',port=6379,db=0)
sub = r.pubsub()
sub.subscribe(['ping','vping'])

while True:
		packet = next(sub.listen())
		channel = packet['channel']
		if channel == "ping":
				pub.publish('pong', packet['data'])
		elif channel == "vping":
				pub.publish('pong', 'python')
