# current dir
curdir := `basename $(shell pwd)`
user := $(shell id -nu)
uid := $(shell id -u)
group := $(shell id -ng)
gid := $(shell id -g)

run:
	make git_clean
	make set
	make build  # default Gemfile(rails) install
	make rails_new
	make bundle_add
	make build  # app Gemfile install
	make db_create
	make up
set:
	sed -i "s/APP_NAME=.*/APP_NAME=${curdir}/" .env
	sed -i "s/APP_USER=.*/APP_USER=${curdir}/" .env
	sed -i "s/APP_USER_ID=.*/APP_USER_ID=${uid}/" .env
	sed -i "s/APP_GROUP=.*/APP_GROUP=${curdir}/" .env
	sed -i "s/APP_GROUP_ID=.*/APP_GROUP_ID=${gid}/" .env
rails_new:
	docker-compose run app rails new . --force -d mysql --skip-action-mailbox --skip-active-storage --skip-action-cable -S --skip-spring --skip-test --skip-bundle --skip-bootsnap --skip-webpack-install --api
bundle_add:
	docker-compose run app bundle add pry-rails --group "development,test" --skip-install
	docker-compose run app bundle add pry-doc --group "development,test" --skip-install
db_create:
	sed -ie "s/host: localhost/host: db/" config/database.yml
	docker-compose run app ruby bin/await_db_connection.rb # db起動待ち
	docker-compose run app rails db:create
git_clean:
	rm -rf .git*
build:
	docker-compose build
up:
	docker-compose up -d
down:
	docker-compose down
mysql:
	docker-compose exec db mysql -u root -p ${curdir}_development
docker_image_clean:
	docker images --format "{{.Repository}}" | grep ${curdir} | xargs docker rmi
docker_stop_all:
	docker ps --format {{.Names}} --filter name=${curdir} | xargs docker stop
docker_prune:
	docker system prune -f
docker_containers:
	docker container ls -a --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
