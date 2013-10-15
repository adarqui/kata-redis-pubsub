# my janky makefile

run:

	make run_python
	make run_ruby
	make run_perl

run_perl:
	perl perl/perl.pl --kata-redis-pubsub > /dev/null 2>&1 &

run_ruby:
	ruby ruby/ruby.pl --kata-redis-pubsub > /dev/null 2>&1 &

run_python:
	python python/python.py --kata-redis-pubsub > /dev/null 2>&1 &

kill:

	pkill -f kata-redis-pubsub

deps:

	make deps_python

deps_python:

	sudo apt-get install python-pip
	pip install redis

deps_ruby:
	if [ ! `which ruby` ] ; then apt-get install ruby1.9.1 ; fi
	gem install redis

deps_perl:
	cpan force install Redis

deps_go:

deps_nodejs:

