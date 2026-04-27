build:
	gem build hashes_equal.gemspec
	echo ">> gem push_hashes_equal-x.y.z.gem, to release this new version!"

docker_bash:
	docker compose run --rm hashes_equal_gem bash

docker_build:
	docker compose up --build

lint:
	bundle exec rubocop

tests:
	bundle exec rake test
