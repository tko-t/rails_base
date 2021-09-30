# current dir
curdir := `basename $(shell pwd)`

run:
	make set
	make build
	make db_create
	make git_clean
	make up
set:
	sed -i "s/USER=.*/USER=${USER}/" .env
	sed -i "s/GROUP=.*/GROUP=${USER}/" .env
	sed -i "s/APP_NAME=.*/APP_NAME=${curdir}/" .env
build:
	docker-compose run api rails new . --force -d mysql --skip-action-mailbox --skip-active-storage --skip-action-cable -S --skip-spring --skip-system-test --skip-bundle --skip-bootsnap --skip-webpack-install --api
	docker-compose build
db_create:
	sed -ie "s/host: localhost/host: db/" config/database.yml
	docker-compose run api rails db:create
git_clean:
	rm -rf .git*
	git init
up:
	docker-compose up -d
