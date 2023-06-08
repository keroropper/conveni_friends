FROM ruby:3.2.1 AS base

FROM base AS builder
RUN apt-get update -qq \
    && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && npm install --global yarn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN gem update --system && gem install bundler:2.4.12

FROM builder AS main
WORKDIR /app
COPY Gemfile /app
COPY Gemfile.lock /app
RUN bundle install --jobs=4 --retry=3

COPY . /app
RUN yarn install --check-files
RUN bundle exec rails webpacker:compile

COPY ./entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh  
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]