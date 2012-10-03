require 'digest/md5'

module UsersHelper
  def gravatar_url(user, size="40")
    hash = Digest::MD5.hexdigest(user.email.downcase)
    "http://www.gravatar.com/avatar/#{hash}?s=#{size.to_i}"
  end
end
