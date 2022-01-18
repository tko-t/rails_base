### rails環境をササっと作りたいときに

### 確認済みの動作環境

> os: Microsoft Windows 10 Pro  
> version: 10.0.19043  
> WSL2: Ubuntu 20.04.1 LTS  
> Docker: 20.10.8, build 3967b7d

### コンテナ環境

> ruby:3.1-alpine  
> rails:latest  
> db:mysql:8

### 使い方

```sh
$ mkdir app_name && $_
$ git clone git@github.com:tko-t/rails_base.git .
$ vi .env
=> 自分の環境に合わせて編集。特にUSERとGROUPとAPP_PORT

$ docker-compose build
$ docker-compose run app rails new . --force -d mysql --skip-action-mailbox --skip-active-storage --skip-action-cable -S --skip-spring --skip-system-test --skip-bundle --skip-bootsnap --skip-webpack-install --api
=> mysqlは固定。他のオプションはお好きに。

$ rm -rf .git*
$ git init
$ docker-compose build
=> rails new で上書きしたGemfileのインストールが走る
$ sed -ie "s/host: localhost/host: db/" config/database.yml
$ docker-compose run app rails db:create
$ docker-compose up
```

or

```sh
$ mkdir app_name && $_
$ git clone git@github.com:tko-t/rails_base.git .
$ make

"ユーザー名とアプリケーション名を実行環境から適当に拾って作ります。
```

http://localhost:$APP_PORT}/ にアクセス
