build:
	gem build hashes_equal.gemspec

lint:
	bundle exec rubocop

tests:
	bundle exec rake test
