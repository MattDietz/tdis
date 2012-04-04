class Rofl < ActiveRecord::Base
  has_attachment :content_type => :image,
                  :storage => :file_system,
	          :size => 1..2.megabyte,
                  :path_prefix => 'public/images'

  validates_as_attachment

  def before_save
    self.filename = "#{MD5.hexdigest("BORBORKBORKROFL#{Time.now.utc}_#{self.filename}")}#{ File.extname(self.filename)}"
  end
end
