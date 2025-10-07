FROM ruby:3.2.2-slim-bullseye
WORKDIR /app

# Install system dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev default-libmysqlclient-dev libsqlite3-dev pkg-config nodejs ruby-dev
COPY Gemfile ./

# Install Ruby gems
RUN bundle --full-index
RUN bundle install --jobs 4 --retry 3

COPY . .

EXPOSE 8080
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
