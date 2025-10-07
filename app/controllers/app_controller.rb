require 'sinatra/base'
require 'sinatra/activerecord'

class AppController < Sinatra::Base
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, 'public'

  configure :development, :production do
    enable :logging
  end

  helpers do
    def recent_pastes
      Paste.order(created_at: :desc).limit(5)
    end

    def format_time_ago(time)
      diff_seconds = Time.now - time
      case diff_seconds
      when 0..59
        "#{diff_seconds.to_i} seconds ago"
      when 60..3599
        "#{(diff_seconds / 60).to_i} minutes ago"
      when 3600..86399
        "#{(diff_seconds / 3600).to_i} hours ago"
      when 86400..2591999
        "#{(diff_seconds / 86400).to_i} days ago"
      else
        time.strftime("%b %d, %Y")
      end
    end

    def format_content_size(content)
      size_bytes = content.bytesize
      case size_bytes
      when 0..1023
        "#{size_bytes} B"
      when 1024..1048575
        "#{(size_bytes / 1024.0).round(2)} KB"
      else
        "#{(size_bytes / 1048576.0).round(2)} MB"
      end
    end
  end
end
