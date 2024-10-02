FROM ruby:3.1

# Yarnのレポジトリを有効化。レポジトリのGPGキーをcurlコマンドを使って取得する(debianはubuntuと互換性がある)
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

# YarnのAPTパッケージレポジトリを自分のシステムに追加。teeコマンドを使って書き込み。
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# レポジトリがシステムに加えられたらパッケージリストをアップデートしてからYarnをインストールする
RUN apt-get update -qq
RUN apt-get install -y nodejs yarn
RUN gem install bundler

# Dockerコンテナ上の作業ディレクトリ
WORKDIR /app

# ローカル開発環境の./src配下の内容をDockerコンテナ上の/appにコピー
COPY ./src /app

# gemファイルのインストール
RUN bundle config --local set path 'vendor/bundle' && bundle install
