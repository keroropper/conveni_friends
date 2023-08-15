FROM ruby:3.1.1 AS base 

WORKDIR /app 
ENV RAILS_ENV production
ENV NODE_MAJOR_VERSION 14
ENV BUNDLE_DEPLOYMENT true
ENV BUNDLE_PATH vendor/bundle
ENV BUNDLE_WITHOUT development:test
RUN gem update --system && gem install bundler:2.4.8
RUN mkdir -p tmp/pids
RUN mkdir -p tmp/sockets
#builder

FROM base AS builder 

RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR_VERSION.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    vim locales build-essential curl libpq-dev libmariadb-dev nodejs yarn nginx sudo

#bundle
FROM builder AS bundle
COPY Gemfile Gemfile.lock ./
#4つのジョブでgemを並列インストール、エラー時に3回まで再試行する。
RUN bundle install --jobs=4 --retry=3 && rm -rf $BUNDLE_PATH/ruby/3.1.1/cache/*

#yarn
FROM builder AS yarn
COPY package.json yarn.lock ./
# --productionはproductionに関係するパッケージ、--frozen-lockfileでバージョンの整合性を保つ
RUN yarn install --production --frozen-lockfile && yarn cache clean 

#main
FROM builder AS main 

COPY . /app
COPY --from=bundle /app/vendor/bundle /app/vendor/bundle 
COPY --from=yarn /app/node_modules /app/node_modules
# docker buildx build -f docker/production/Dockerfile --secret id=master_key,src=./config/master.key -t conveni_friends-prod .
RUN --mount=type=secret,id=master_key,target=config/master.key,required=true bundle exec rails webpacker:compile RAILS_ENV=production
#webpackをproduction環境で実行
RUN chmod +x ./bin/webpack
RUN NODE_ENV=production ./bin/webpack
# RUN RAILS_ENV=production bundle exec rails webpacker:compile

COPY docker/production/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

VOLUME /app/public
VOLUME /app/tmp
CMD bash -c "rm -f tmp/pids/server.pid && bundle exec puma -C config/puma.rb -e production"



