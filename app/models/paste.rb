class Paste < ActiveRecord::Base
  def private?
    visibility == 'private'
  end
end
