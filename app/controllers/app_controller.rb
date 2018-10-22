class AppController < Sinatra::Base
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, 'public'

  configure :development, :production do
    enable :logging
  end
end
