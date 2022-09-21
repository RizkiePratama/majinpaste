# Require sinatra base
require 'sinatra/base'
require 'sinatra/activerecord'

# Make Sure App Controller Loaded First
require './app/controllers/app_controller.rb'

# Then Require the rest of our controllers
Dir.glob('./app/controllers/*.rb')
  .reject { |f| f.include? 'app_controller.rb' }
  .each { |controller| require controller }

# Then load our routes
run PasteController.new!
