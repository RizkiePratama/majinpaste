FROM ruby:3.0.6-slim-bullseye
WORKDIR /app

# Install system dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev default-libmysqlclient-dev nodejs
COPY Gemfile Gemfile.lock ./

# Install Ruby gems
RUN bundle install --jobs 4 --retry 3

COPY . .

EXPOSE 8080
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
