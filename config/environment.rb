require "bundler"
Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

require_all 'app'