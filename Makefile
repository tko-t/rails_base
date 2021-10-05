# current dir
curdir := `basename $(shell pwd)`
user := $(shell id -nu)
uid := $(shell id -u)
group := $(shell id -ng)
gid := $(shell id -g)

run:
	make set
	make build
	make db_create
	make git_clean
	make up
set:
	sed -i "s/USER=.*/USER=${user}/" .env
	sed -i "s/USER_ID=.*/USER_ID=${uid}/" .env
	sed -i "s/GROUP=.*/GROUP=${group}/" .env
	sed -i "s/GROUP_ID=.*/GROUP_ID=${gid}/" .env
	sed -i "s/APP_NAME=.*/APP_NAME=${curdir}/" .env
build:
	docker-compose run app rails new . --force -d mysql --skip-action-mailbox --skip-active-storage --skip-action-cable -S --skip-spring --skip-system-test --skip-bundle --skip-bootsnap --skip-webpack-install --api
	docker-compose build
db_create:
	sed -ie "s/host: localhost/host: db/" config/database.yml
	docker-compose run app rails db:create
git_clean:
	rm -rf .git*
	git init
up:
	docker-compose up -d
docker_containers:
	docker container ls -a --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
