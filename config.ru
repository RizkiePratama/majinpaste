# Require sinatra base
require 'yaml'
require 'sinatra/base'
require 'active_record'

# Init DB Connection
db = YAML.load_file('./config/database.yml')['development']
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: db['host'],
  username: db['user'],
  password: db['password'],
  database: db['database']
)

# Then Require Model
Dir.glob('./app/models/*.rb').each { |model| require model }

# Make Sure App Controller Loaded First
require './app/controllers/app_controller.rb'

# Then Require the rest of our controllers
Dir.glob('./app/controllers/*.rb')
  .reject { |f| f.include? 'app_controller.rb' }
  .each { |controller| require controller }

# Then load our routes
run PasteController.new
