# my janky makefile

run:

	python python/python.py --kata-redis-pubsub > /dev/null 2>&1 &

kill:

	pkill -f kata-redis-pubsub

build:

deps:

	make deps_python

deps_python:

	sudo apt-get install python-pip
	pip install redis

deps_ruby:
	if [ ! `which ruby` ] ; then apt-get install ruby1.9.1 ; fi
	gem install redis
