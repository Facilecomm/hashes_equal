build:
	gem build hashes_equal.gemspec & echo ">> gem push_hashes_equal-x.y.z.gem, to release this new version!"

lint:
	bundle exec rubocop

tests:
	bundle exec rake test
