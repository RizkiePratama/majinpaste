# Require sinatra base
require 'sinatra/base'
require 'sinatra/activerecord'
require 'require_all'

# Make Sure App Controller Loaded First
require_all 'app/controllers'

run PasteController.new
