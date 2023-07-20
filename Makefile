.PHONY: install, test, lint, format, console, bash

install:
	docker-compose exec app bundle install

test:
	docker-compose exec app bundle exec rspec

lint:
	docker-compose exec app bundle exec rubocop

format:
	docker-compose exec app bundle exec rubocop -A

console:
	docker-compose exec app bundle exec rails c

seed:
	docker-compose exec app bundle exec rails db:seed

bash:
	docker-compose exec app bash
