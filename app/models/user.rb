require 'md5'
class User < ActiveRecord::Base
  def before_create
    self.salt = MD5.hexdigest "BORKBORKTHEDAYISSHOTBORK#{Time.now.utc}"
    self.password = self.salted_password(self.password)
  end

  def self.find_matching_user(name)
    u = find(:first, :conditions => ["name = ?", name])
    u if u && u.password_matches?
  end

  def password_matches?(passwd)
    self.password == self.salted_password(passwd)
  end

  def self.salted_password(passwd)
    MD5.hexdigest("#{passwd}#{salt}")
  end

end
