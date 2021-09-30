build:
	docker-compose run api rails new . --force -d mysql --skip-action-mailbox --skip-active-storage --skip-action-cable -S --skip-spring --skip-system-test --skip-bundle --skip-bootsnap --skip-webpack-install --api
	docker-compose build
git_clean:
	rm -rf .git*
	git init
db_create:
	sed -ie "s/host: localhost/host: db/" config/database.yml
	docker-compose run api rails db:create
up:
	docker-compose up -d
