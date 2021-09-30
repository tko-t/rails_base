### rails環境をササっと作りたいときに

### 確認済みの動作環境

> os: Microsoft Windows 10 Pro
> version: 10.0.19043
> WSL2: Ubuntu 20.04.1 LTS
> Docker: 20.10.8, build 3967b7d

### コンテナ環境

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

or

```sh
$ git clone git@github.com:tko-t/rails_base.git app_name
$ cd app_name
$ make

"ユーザー名とアプリケーション名を実行環境から適当に拾ってきます。
```

http://localhost:3000/ にアクセス


