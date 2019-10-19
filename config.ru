# Require sinatra base
require 'yaml'
require 'erb'
require 'sinatra/base'
require 'active_record'

# Init DB Connection
db = YAML.load(ERB.new(File.read('./config/database.yml')).result)['development']
ActiveRecord::Base.establish_connection(
  adapter: db['adapter'],
  host: db['host'],
  username: db['user'],
  password: db['pass'],
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
