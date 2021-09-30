### rails環境をササっと作りたいときに

### 環境

> ruby:3.0-alpine  
> rails:latest  
> db:mysql5.7


### 使い方

```sh
$ git clone git@github.com:tko-t/rails_base.git app_name

$ cd app_name

$ vi .env
=> 自分の環境に合わせて編集。特にUSERとGROUP

$ docker-compose run api rails new . --force -d mysql --skip-action-mailbox --skip-active-storage --skip-action-cable -S --skip-spring --skip-system-test --skip-bundle --skip-bootsnap --skip-webpack-install --api
=> mysqlは固定。他のオプションはお好きに。

$ rm -rf .git*

$ git init

$ docker-compose build

$ sed -ie "s/host: localhost/host: db/" config/database.yml

$ docker-compose run api rails db:create

$ docker-compose up
```

http://localhost:3000/ にアクセス


