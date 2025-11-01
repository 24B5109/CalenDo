# syntax = docker/dockerfile:1
# ベース Ruby イメージ（あなたの .ruby-version と一致）
ARG RUBY_VERSION=3.2.7
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim AS base
# Rails アプリの作業ディレクトリ
WORKDIR /rails
# 本番環境設定
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"
# 必要なLinuxパッケージをインストール
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libvips \
    curl \
    git \
    pkg-config \
    libyaml-dev \
    libpq5 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives
# Gemfile / Gemfile.lock をコピーしてGemをインストール
COPY Gemfile Gemfile.lock ./
# Linux用のGemfile.lockを更新（Windows由来対策）
RUN bundle lock --add-platform x86_64-linux
# 依存関係をインストール
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git
# アプリケーションコードをコピー
COPY . .
# bootsnap のプリコンパイルは削除（Linuxで失敗しやすいため）
# RUN bundle exec bootsnap precompile app/ lib/
# binファイルをLinux実行可能に調整
RUN chmod +x bin/* && \
    sed -i 's/\r$//' bin/* && \
    sed -i 's/^.*ruby.exe.*$/#!\/usr\/bin\/env ruby/' bin/*
# アセットを事前コンパイル
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile
# 実行用ステージ
FROM base
# 非rootユーザーで実行（セキュリティ目的）
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /rails /usr/local/bundle
USER rails:rails
EXPOSE 3000
# Rails起動
CMD ["./bin/rails", "server"]