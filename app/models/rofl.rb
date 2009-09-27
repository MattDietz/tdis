class Rofl < ActiveRecord::Base
  acts_as_attachment(
    :storage => :file_system, 
    :file_system_path => 'public/images'
  )
  validates_as_attachment

  

end
