.PHONY: install, test, lint, format

install:
	docker-compose exec app bundle install

test:
	docker-compose exec app bundle exec rspec

lint:
	docker-compose exec app bundle exec rubocop

format:
	docker-compose exec app bundle exec rubocop -A
