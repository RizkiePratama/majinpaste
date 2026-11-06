require 'securerandom'
require 'digest'
require 'gibberish' 

class PasteController < AppController
  enable :sessions

  get '/' do
    langArr = []

    erb :index, :layout => :layout, :locals => {:lang => langArr, :recent_pastes => recent_pastes}
  end

  get '/:slug' do
    paste = Paste.find_by(slug: params['slug'])
    if !paste.nil?
      if paste.private? && !paste_unlocked?(paste)
        return erb :private_paste, :layout => :layout, :locals => {:paste => paste, :error_message => nil}
      end

      cipher = Gibberish::AES.new('p4ssw0rd')
      paste.content = cipher.decrypt(paste.content)
      p paste.content
      erb :paste, :layout => :layout, :locals => {:paste => paste, :recent_pastes => recent_pastes}
    else
      status 404
      erb :not_found, :layout => :layout
    end
  end

  post '/:slug/unlock' do
    paste = Paste.find_by(slug: params['slug'])
    redirect '/' unless paste && paste.private?

    if Digest::SHA256.hexdigest(params['password'].to_s) == paste.password_digest
      session["paste_unlocked_at_#{paste.slug}"] = Time.now.to_i
      redirect "/#{paste.slug}"
    end

    status 422
    erb :private_paste, :layout => :layout, :locals => {:paste => paste, :error_message => 'Incorrect password'}
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
    paste.visibility = params['paste']['protected'] == '1' ? 'private' : 'public'
    if paste.private? && params['paste']['password'].to_s.strip.empty?
      status 422
      return erb :index, :layout => :layout, :locals => {
        :lang => [],
        :recent_pastes => recent_pastes,
        :error_message => 'Protected pastes require a password'
      }
    end
    paste.password_digest = Digest::SHA256.hexdigest(params['paste']['password'].to_s) if paste.private?

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

  helpers do
    def paste_unlocked?(paste)
      unlocked_at = session["paste_unlocked_at_#{paste.slug}"]
      unlocked_at && (Time.now.to_i - unlocked_at) < 300
    end
  end

end
