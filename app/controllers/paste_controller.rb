require 'securerandom'
require 'gibberish' 

class PasteController < AppController

  get '/' do
    langArr = []

    erb :index, :layout => :layout, :locals => {:lang => langArr, :recent_pastes => recent_pastes}
  end

  get '/:slug' do
    paste = Paste.find_by(slug: params['slug'])
    if !paste.nil?
      cipher = Gibberish::AES.new('p4ssw0rd')
      paste.content = cipher.decrypt(paste.content)
      p paste.content
      erb :paste, :layout => :layout, :locals => {:paste => paste, :recent_pastes => recent_pastes}
    else
      status 404
      erb :not_found, :layout => :layout
    end
  end

  post '/create' do
    content = params['paste']['content'].to_s
    if content.strip.empty?
      status 422
      return erb :index, :layout => :layout, :locals => {
        :lang => [],
        :recent_pastes => recent_pastes,
        :error_message => 'Paste content cannot be empty'
      }
    end

    paste = Paste.new
    paste.lang = params['paste']['lang']

    cipher = Gibberish::AES.new('p4ssw0rd')
    paste.content = cipher.encrypt(content)
    isNotUnique = true
    while(isNotUnique)
      slug = SecureRandom.hex(5)
      if(Paste.find_by(slug: slug).nil?)
        isNotUnique = false
        paste.slug = slug
      end
    end

    paste.save
    redirect '/' + paste.slug
  end

end
